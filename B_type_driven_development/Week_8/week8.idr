import Data.Vect
import Data.List.Views
import Data.Vect.Views
import Data.Nat.Views

-- Page 270
-- Exercise 1
data TakeN : List a -> Type where
  Fewer : TakeN xs
  Exact : (n_xs : List a) -> TakeN (n_xs ++ rest)

takeN : (n : Nat) -> (xs : List a) -> TakeN xs
takeN Z _ = Exact []
takeN (S k) [] = Fewer
takeN (S k) (x :: xs) = case takeN k xs of
                             Fewer => Fewer
                             Exact n_xs => Exact (x :: n_xs)

groupByN : (n : Nat) -> (xs : List a) -> List (List a)
groupByN n xs with (takeN n xs)
  groupByN n xs | Fewer = [xs]
  groupByN n (n_xs ++ rest) | (Exact n_xs) = n_xs :: groupByN n rest

-- Exercise 2
halves : List a -> (List a, List a)
halves xs with (takeN ((length xs) `div` 2) xs)
  halves xs | Fewer = ([], xs)
  halves (n_xs ++ rest) | Exact (n_xs) = (n_xs, rest)


-- Page 279
-- Exercise 1
equalSuffix : Eq a => List a -> List a -> List a
equalSuffix x y with (snocList x)
  equalSuffix [] y | Empty = []
  equalSuffix (xs ++ [x_item]) y | (Snoc recX) with (snocList y)
    equalSuffix (xs ++ [x_item]) [] | (Snoc recX) | Empty = []
    equalSuffix (xs ++ [x_item]) (ys ++ [y_item]) | (Snoc recX) | (Snoc recY) =
      if x_item == y_item then equalSuffix xs ys | recX | rexY ++ [x_item] else []

-- Exercise 4
total
palindrome : Eq a => List a -> Bool
palindrome xs with (vList xs)
  palindrome [] | VNil = True
  palindrome [x] | VOne = True
  palindrome (first :: (ys ++ [last])) | (VCons rec) =
    (first == last) && palindrome ys | rec


-- Page 287
-- Exercise 2
export
data Shape = Triangle Double Double
           | Rectangle Double Double
           | Circle Double
{-
area : Shape -> Double
area s with (shapeView s)
  area (triangle base height) | STriangle = ?area_rhs_1
  area (rectangle width height) | SRectangle = ?area_rhs_2
  area (circle radius) | SCircle = ?area_rhs_3
-}

-- Page 304
-- Exercise 1
total
every_other : Stream a -> Stream a
every_other (x :: _ :: xs) = x :: every_other xs

-- Exercise 2
data InfList : Type -> Type where
  (::) : (value : elem) -> Inf (InfList elem) -> InfList elem

%name InfList xs, ys, zs

Functor InfList where
  map f (value :: xs) = f value :: map f xs

-- Exercise 4
total
square_root_approx : (number : Double) -> (approx : Double) -> Stream Double
square_root_approx number approx =
  let next = (approx + (number / approx)) / 2 in -- Newton's method
  approx :: square_root_approx number next

total
square_root_bound : (max : Nat) -> (number : Double) -> (bound : Double) -> (approxs : Stream Double) -> Double
square_root_bound Z number bound (val :: xs) = val
square_root_bound (S k) number bound (val :: xs) =
  if abs(val*val - number) < bound
    then val
    else square_root_bound k number bound xs

total
square_root : (number : Double) -> Double
square_root number =
  let recursiveCall = square_root_approx number number in
  square_root_bound 100 number 0.00000000001 recursiveCall


-- Page 314
-- Exercise 1
data InfIO : Type where
  Do : IO a
       -> (a -> Inf InfIO)
       -> InfIO

total
totalREPL : (prompt : String) -> (action : String -> String) -> InfIO
totalREPL prompt action = Do (putStrLn prompt) (\_ => totalREPL prompt action)

-- Page 322
-- Exercise 1
-- (Done in class)
