import Data.Vect
import Data.String
import System

-- Page 110: 1 - 5

-- Exercise 1
-- Extend the Vehicle data type so that it supports
-- unicycles and motorcycles, and update wheels and refuel accordingly.

-- Exercise 2
-- Extend the PowerSource and Vehicle data types to support electric vehicles
-- (such as trams or electric cars).

data PowerSource = Petrol | Pedal | Electric
data Vehicle : PowerSource -> Type where
  Unicycle : Vehicle Pedal
  Bicycle : Vehicle Pedal
  Motorcycle : (fuel : Nat) -> Vehicle Petrol
  Car : (fuel : Nat) -> Vehicle Petrol
  Bus : (fuel : Nat) -> Vehicle Petrol
  Tram : Vehicle Electric

wheels : Vehicle power -> Nat
wheels Bicycle = 2
wheels (Car fuel) = 4
wheels (Bus fuel) = 4
wheels Unicycle = 1
wheels (Motorcycle fuel) = 2
wheels Tram = 0

refuel : Vehicle Petrol -> Vehicle Petrol
refuel (Car fuel) = Car 100
refuel (Bus fuel) = Bus 200
refuel (Motorcycle fuel) = Motorcycle 50

-- Exercise 3
-- The take function, on List, has type Nat -> List a -> List a. What’s an
-- appropriate type for the corresponding vectTake function on Vect?
-- Hint: How do the lengths of the input and output relate? It shouldn’t be
-- valid to take more elements than there are in the Vect. Also, remember that
-- you can have any expression in a type.

-- The answer is
-- take : (n : Nat) -> Vect (n + m) elem -> Vect n elem
-- which in fact can be obtained just by doing
-- :t Vect.take on a terminal

-- Exercise 4
vectTake : (n : Nat) -> Vect (n + m) elem -> Vect n elem
vectTake Z xs = []
vectTake (S k) (x :: xs) = [x] ++ vectTake k xs

-- Exercise 5
sumEntriesFin : Num a => Maybe (Fin n) -> (xs : Vect n a) -> (ys : Vect n a) -> Maybe a
sumEntriesFin Nothing xs ys = Nothing
sumEntriesFin (Just i) xs ys = Just $ index i xs + index i ys

sumEntries : Num a => (pos : Integer) -> Vect n a -> Vect n a -> Maybe a
sumEntries {n} pos xs ys = sumEntriesFin (integerToFin pos n) xs ys


-- Page 131: 1 - 2
-- Exercise 1
printLonger : IO()
printLonger = do
                x <- getLine
                y <- getLine
                let xl = length x
                let yl = length y
                let m = max xl yl
                putStrLn (show m)

-- Exercise 2
printLonger' : IO()
printLonger' = getLine >>= \x =>
               getLine >>= \y =>
               let xl = length x in
               let yl = length y in
               let m = max xl yl in
               putStrLn (show m)


-- Page 138: 1 - 4
-- Exercise 1

makeMessage: (guess : Maybe Integer) -> (target : Integer) -> (String, Bool)
makeMessage Nothing target = ("Please input a number", True)
makeMessage (Just g) target =
  if g == target then ("Correct!", False) else
  if g < target then ("Too low", True)
    else ("Too high", True)

guess : (target : Integer) -> IO ()
guess target = do
  putStrLn "Choose a number"
  l <- getLine
  let i = parseInteger l
  let (message, continue) = makeMessage i target
  putStrLn message
  if continue then (guess target) else pure()

-- Exercise 2

main : IO()
main = do
    putStrLn "Welcome to the guessing show!"
    putStrLn ""
    number <- time
    guess number

-- Exercise 3
guess' : (target : Integer) -> (guesses : Nat) -> IO ()
guess' target guesses = do
  putStrLn $ "You have tried " ++ show guesses ++ " times"
  putStrLn "Choose a number"
  l <- getLine
  let i = parseInteger l
  let (message, continue) = makeMessage i target
  putStrLn message
  if continue then (guess' target (S guesses)) else pure()

-- Exercise 4
--repl' : String -> (String -> String) -> IO ()
--repl' x f = do
--  putStrLn (f x)
--  repl' x f

--replWith' : (state : a) -> (prompt : String) ->
--            (onInput : a -> String -> Maybe (String, a)) -> IO ()
-- replWith' state prompt onInput = ?replWith'_rhs


-- Page 145: 1 - 3
-- Exercise 1

-- Source: https://gist.github.com/PeterHajdu/0a4a0de909660921e5da1034e8b17360#file-readtoblank-idr-L5
readToBlank : IO (List String)
readToBlank = do
  line <- getLine
  if line == "" then pure [] else (line ::) <$> readToBlank
  -- Not really sure how to implement the last part!

-- Exercise 2
readAndSave : IO ()
readAndSave = do
  lines <- readToBlank
  let content = concat lines
  filename <- getLine
  Right () <- writeFile filename content
    | Left err => putStrLn (show err)
  pure ()

-- Exercise 3
-- readVectFile : (filename : String) -> IO (n ** Vect n String)
-- readVectFile filename = do
--  Right file <- openFile filename Read
--    | Left err => do
--      putStrLn "Error while reading file"
--      pure (0 ** [])
--  let content = ...
