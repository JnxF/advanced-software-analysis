import Data.Vect

-- Page 160

-- Exercise 1
Matrix : Nat -> Nat -> Type
Matrix n m = Vect n (Vect m Double)

-- Exercise 2
data Format = Number Format
            | Str Format
            | Lit String Format
            | Ch Format
            | Dbl Format
            | End

PrintfType : Format -> Type
PrintfType (Number fmt) = (i : Int) -> PrintfType fmt
PrintfType (Str fmt) = (str : String) -> PrintfType fmt
PrintfType (Lit str fmt) = PrintfType fmt
PrintfType (Ch fmt) = (c : Char) -> PrintfType fmt
PrintfType (Dbl fmt) = (d : Double) -> PrintfType fmt
PrintfType End = String

printfFmt : (fmt : Format) -> (acc : String) -> PrintfType fmt
printfFmt (Number fmt) acc = \i => printfFmt fmt (acc ++ show i)
printfFmt (Str fmt) acc = \str => printfFmt fmt (acc ++ str)
printfFmt (Ch fmt) acc = \c => printfFmt fmt (acc ++ show c)
printfFmt (Dbl fmt) acc = \d => printfFmt fmt (acc ++ show d)
printfFmt (Lit lit fmt) acc = printfFmt fmt (acc ++ lit)
printfFmt End acc = acc

toFormat : (xs : List Char) -> Format
toFormat [] = End
toFormat ('%' :: 'd' :: chars) = Number (toFormat chars)
toFormat ('%' :: 's' :: chars) = Str (toFormat chars)
toFormat ('%' :: 'c' :: chars) = Ch (toFormat chars)
toFormat ('%' :: 'f' :: chars) = Dbl (toFormat chars)
toFormat ('%' :: chars) = Lit "%" (toFormat chars)
toFormat (c :: chars) = case toFormat chars of
                             Lit lit chars' => Lit (strCons c lit) chars'
                             fmt => Lit (strCons c "") fmt
printf : (fmt : String) -> PrintfType (toFormat (unpack fmt))
printf fmt = printfFmt _ ""

-- Exercise 3
TupleVect : Nat -> Type -> Type
TupleVect Z e = ()
TupleVect (S k) e = (e, TupleVect k e)

-- test : TupleVect 4 Nat
-- test = (1,2,3,4,())


-- Page 180
-- See file `week7_1_p_180.idr`


-- Page 193

data Shape = Triangle Double Double
           | Rectangle Double Double
           | Circle Double

-- Exercise 1

Eq Shape where
  (==) (Triangle a b) (Triangle a' b') = (a == a' && b == b')
  (==) (Rectangle a b) (Rectangle a' b') = (a == a' && b == b')
  (==) (Circle r) (Circle r') = (r == r')
  (==) _ _ = False

-- Exercise 2

area : Shape -> Double
area (Triangle base height) = 0.5 * base * height
area (Rectangle length height) = length * height
area (Circle radius) = pi * radius * radius

Ord Shape where
  compare s1 s2 = compare (area s1) (area s2)

-- testShapes : List Shape
-- testShapes = [Circle 3, Triangle 3 9, Rectangle 2 6, Circle 4,
--               Rectangle 2 7]


-- Page 199

-- Exercise 1
data Expr num = Val num
              | Add (Expr num) (Expr num)
              | Sub (Expr num) (Expr num)
              | Mul (Expr num) (Expr num)
              | Div (Expr num) (Expr num)

eval : (Neg num, Integral num) => Expr num -> num
eval (Val x) = x
eval (Add x y) = eval x + eval y
eval (Sub x y) = eval x - eval y
eval (Mul x y) = eval x * eval y
eval (Div x y) = eval x `div` eval y

Num ty => Num (Expr ty) where
    (+) = Add
    (*) = Mul
    fromInteger = Val . fromInteger

Neg ty => Neg (Expr ty) where
    negate x = 0 - x
    (-) = Sub

Show t => Show (Expr t) where
  show (Val x) = show x
  show (Add x y) = "(" ++ (show x) ++ " + " ++ (show y) ++ ")"
  show (Sub x y) = "(" ++ (show x) ++ " - " ++ (show y) ++ ")"
  show (Mul x y) = "(" ++ (show x) ++ " * " ++ (show y) ++ ")"
  show (Div x y) = "(" ++ (show x) ++ " / " ++ (show y) ++ ")"

-- show (the (Expr _) (6 + 3 * 12))
-- show (the (Expr _) (6 * 3 + 12))

-- Exercise 2
(Eq num, Integral num, Neg num) => Eq (Expr num) where
    (==) x y = eval x == eval y

-- Exercise 3
(Integral num, Neg num) => Cast (Expr num) num where
  cast x = eval (x)


-- Page 206

-- Exercise 1
Functor Expr where
  map f (Val x) = Val (f x)
  map f (Add x y) = Add (map f x) (map f y)
  map f (Sub x y) = Sub (map f x) (map f y)
  map f (Mul x y) = Mul (map f x) (map f y)
  map f (Div x y) = Div (map f x) (map f y)

-- Exercise 2
-- See file `week7_1_p_206_ex_2.idr`
