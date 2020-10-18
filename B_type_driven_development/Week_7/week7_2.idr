import Data.Vect

-- Page 219
-- Exercise 1
same_cons : {xs : List a} -> {ys : List a} -> xs = ys -> x :: xs = x :: ys
same_cons Refl = Refl

-- Exercise 2
same_lists : {xs : List a} -> {ys : List a} -> x = y -> xs = ys -> x :: xs = y :: ys
same_lists Refl Refl = Refl

-- Exercise 3
data ThreeEq : a -> b -> c -> Type where
  Same : ThreeEq x x x

-- Exercise 4
allSameS : (x, y, z : Nat) -> ThreeEq x y z -> ThreeEq (S x) (S y) (S z)
allSameS x x x (Same) = Same

-- Page 227
-- Exercise 1
myPlusCommutes : (n : Nat) -> (m : Nat) -> n + m = m + n
myPlusCommutes Z m = rewrite plusZeroRightNeutral m in Refl
myPlusCommutes (S k) m = rewrite myPlusCommutes k m in
                         rewrite plusSuccRightSucc m k in Refl

reverseProof_xs : Vect (S (n + len)) a -> Vect (n + (S len)) a
reverseProof_xs xs {n} {len} = rewrite sym(plusSuccRightSucc n len) in xs

-- Exercise 2
reverse' : Vect n a -> Vect m a -> Vect (n + m) a
reverse' acc [] {n} = rewrite plusZeroRightNeutral n in acc
reverse' acc (x :: xs) =
        reverseProof_xs (reverse' (x::acc) xs)

myReverse : Vect n a -> Vect n a
myReverse xs = reverse' [] xs

-- Page 234
-- See file `week7_2_234.idr`

-- Page 249
-- Exercise 2

data Last : List a -> a -> Type where
     LastOne : Last [value] value
     LastCons : (prf : Last xs value) -> Last (x :: xs) value

noLastEmpty : Last [] value -> Void
noLastEmpty LastOne impossible
noLastEmpty (LastCons _) impossible

notLastOne : (contra : (x = value) -> Void) -> Last [x] value -> Void
notLastOne contra LastOne = contra Refl
notLastOne contra (LastCons prf) = noLastEmpty prf

notLastCons : (contra : Last (y :: xs) value -> Void) -> Last (x :: y :: xs) value -> Void
notLastCons contra (LastCons prf) = contra (prf)

isLast : DecEq a => (xs : List a) -> (value : a) -> Dec(Last xs value)
isLast [] value = No (noLastEmpty)
isLast [x] value = case decEq x value of
                    Yes Refl => Yes (LastOne)
                    No contra => No (notLastOne contra)
isLast (x :: y :: xs) value = case isLast (y :: xs) value of
                    Yes prf => Yes (LastCons prf)
                    No contra => No (notLastCons contra)
