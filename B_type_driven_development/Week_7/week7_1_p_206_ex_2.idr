data Vect : Nat -> Type -> Type where
  Nil : Vect Z a
  (::) : (x : a) -> (xs : Vect k a) -> Vect (S k) a

Eq e => Eq (Vect n e) where
  (==) Nil Nil = True
  (==) (x :: xs) (y :: ys) = (x == y) && (xs == ys)
  (==) _ _ = False

Foldable (Vect n) where
  foldr f acc [] = acc
  foldr f acc (x :: xs) = f x (foldr f acc xs)
