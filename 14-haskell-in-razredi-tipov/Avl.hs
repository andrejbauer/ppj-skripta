-- AVL drevesa v Haskellu

module Avl where

  -- višino drevesa merimo s celim številom
  type Height = Integer

  -- koinduktivni podatkovni tip AVL dreves
  data AVLTree a =
      Empty
    | Node a Height (AVLTree a) (AVLTree a)
    deriving Show

  -- primer drevesa
  t :: AVLTree Integer
  t = Node 5 3
      (Node 3 2
       (Node 1 1 Empty Empty)
       (Node 4 1 Empty Empty))
      (Node 8 1 Empty Empty)

  height :: AVLTree a -> Height
  height Empty = 0
  height (Node _ h _ _) = h

  leaf :: a -> AVLTree a
  leaf v = Node v 1 Empty Empty

  -- pametni konstruktor, ki poskrbi za višino
  node :: a -> AVLTree a -> AVLTree a -> AVLTree a
  node v l r = Node v (1 + max (height l) (height r)) l r

  -- drevo t zapisano s pamentim konstruktorjem
  t' :: AVLTree Integer
  t' = node 5
        (node 3
         (node 1 Empty Empty)
         (node 4 Empty Empty))
        (node 8 Empty Empty)

  -- drevo t zapisano še bolje
  t'' :: AVLTree Integer
  t'' = node 5
        (node 3
         (leaf 1)
         (leaf 4))
        (leaf 8)

  -- seznam elementov v drevesu
  toList :: AVLTree a -> [a]
  toList Empty = []
  toList (Node x _ l r) = toList l ++ (x : toList r)

  search :: Ord a => a -> AVLTree a -> Bool
  search x Empty = False
  search x (Node y _ l r) =
      case compare x y of
        EQ -> True
        LT -> search x l
        GT -> search x r

  test1 = search 1 t

  test2 = search 42 t

  rotateLeft :: AVLTree a -> AVLTree a
  rotateLeft (Node x _ a (Node y _ b c)) = node y (node x a b) c
  rotateLeft t = t

  rotateRight :: AVLTree a -> AVLTree a
  rotateRight (Node y _ (Node x _ a b) c) = node x a (node y b c)
  rotateRight t = t

  imbalance :: AVLTree a -> Integer
  imbalance Empty = 0
  imbalance (Node _ _ l r) = height l - height r

  balance :: AVLTree a -> AVLTree a
  balance Empty = Empty
  balance (t @ (Node x _ l r)) =
      case imbalance t of
        2 ->  case imbalance l of
                -1 -> rotateRight (node x (rotateLeft l) r)
                _ ->  rotateRight t
        -2 -> case imbalance r of
                1 -> rotateLeft (node x l (rotateRight r))
                _ -> rotateLeft t
        _ -> t

  add :: Ord a => a -> AVLTree a -> AVLTree a
  add x Empty = leaf x
  add x (t @ (Node y _ l r)) =
      case compare x y of
        EQ -> t
        LT -> balance (node y (add x l) r)
        GT -> balance (node y l (add x r))

  remove :: Ord a => a -> AVLTree a -> AVLTree a
  remove x Empty = Empty
  remove x (Node y _ l r) =
      let removeSuccessor Empty = error "impossible"
          removeSuccessor (Node x _ Empty r) = (r, x)
          removeSuccessor (Node x _ l r) = (balance (node x l' r), y) where (l', y) = removeSuccessor l
      in
        case compare x y of
          LT -> balance (node y (remove x l) r)
          GT -> balance (node y l (remove x r))
          EQ -> case (l, r) of
                  (_, Empty) -> l
                  (Empty, _) -> r
                  _ -> balance (node y' l r') where (r', y') = removeSuccessor r
