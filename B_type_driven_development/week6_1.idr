import Data.Vect

-- Page 50

-- Exercise 2
{- reversei : List Char -> List Char
reversei [] = []
reversei (x :: xs) = reversei xs ++ [x]

reverse : String -> String
reverse x = pack $ reversei $ unpack x -}

-- Exercise 2
palindrome2 : String -> Bool
palindrome2 x = x == reverse x

-- Exercise 3
palindrome3 : String -> Bool
palindrome3 x = toLower x == (reverse $ toLower x)

-- Exercise 6
counts : String -> (Nat, Nat)
counts x = (length $ words x, length x)

-- Exercise 7
top_ten : Ord a => List a -> List a
top_ten xs = take 10 $ reverse $ sort xs

-- Page 75
length_ : List a -> Nat
length_ [] = 0
length_ (x :: xs) = S (length_ xs)

reverse_ : List a -> List a
reverse_ [] = []
reverse_ (x :: xs) = reverse xs ++ [x]

map1_ : (a -> b) -> List a -> List b
map1_ f [] = []
map1_ f (x :: xs) = f x :: (map1_ f xs)

map2_ : (a -> b) -> Vect n a -> Vect n b
map2_ f [] = []
map2_ f (x :: xs) = f x :: (map2_ f xs)

-- Page 82
createEmpties : Vect n (Vect 0 elem)
createEmpties = replicate _ []

--transposeMat : Vect m (Vect n elem) -> Vect n (Vect m elem)
--transposeMat [] = createEmpties
--transposeMat (x :: xs) = ?transposeMat_rhs_2

dotProduct : Num a => Vect m a -> Vect m a -> Vect m a
dotProduct = zipWith (+)

addMatrix : Num a => Vect n (Vect m a) -> Vect n (Vect m a) -> Vect n (Vect m a)
addMatrix l1 l2 = zipWith dotProduct l1 l2

-- Extra
double : Vect n a -> Vect (n * 2) a
double [] = []
double (x :: xs) = [x, x] ++ double xs

-- countTo : (m : Nat) -> Vect m Nat
-- countTo Z = []
-- countTo (S k) = countTo k ++ [S k]


addOrNothing : a -> Maybe (Vect k a) -> Maybe (Vect (S k) a)
addOrNothing x Nothing = Nothing
addOrNothing x (Just xs) = Just (x :: xs)

takeList : (n : Nat) -> List a -> Maybe (Vect n a)
takeList Z xs = Just []
takeList (S k) [] = Nothing
takeList (S k) (x :: xs) = addOrNothing x (takeList k xs)
