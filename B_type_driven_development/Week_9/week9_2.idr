-- Page 371

-- Exercise 1 to 4

import Data.Vect

data StackCmd : Type -> Nat -> Nat -> Type where
     Push : Integer -> StackCmd () height (S height)
     Pop : StackCmd Integer (S height) height
     Top : StackCmd Integer (S height) (S height)

     GetStr : StackCmd String height height
     PutStr : String -> StackCmd () height height

     Pure : ty -> StackCmd ty height height
     (>>=) : StackCmd a height1 height2 ->
             (a -> StackCmd b height2 height3) ->
             StackCmd b height1 height3

runStack : (stk : Vect inHeight Integer) ->
           StackCmd ty inHeight outHeight -> IO (ty, Vect outHeight Integer)
runStack stk (Push val) = pure ((), val :: stk)
runStack (val :: stk) Pop = pure (val, stk)
runStack (val :: stk) Top = pure (val, val :: stk)
runStack stk GetStr = do x <- getLine
                         pure (x, stk)
runStack stk (PutStr x) = do putStr x
                             pure ((), stk)
runStack stk (Pure x) = pure (x, stk)
runStack stk (x >>= f) = do (x', newStk) <- runStack stk x
                            runStack newStk (f x')

testAdd : StackCmd () 0 0
testAdd = do Push 10
             x <- GetStr
             Push (cast x)
             val1 <- Pop
             val2 <- Pop
             PutStr (show (val1 + val2) ++ "\n")

data StackIO : Nat -> Type where
     Do : StackCmd a height1 height2 ->
          (a -> Inf (StackIO height2)) -> StackIO height1

namespace StackDo
     (>>=) : StackCmd a height1 height2 ->
             (a -> Inf (StackIO height2)) -> StackIO height1
     (>>=) = Do

data Fuel = Dry | More (Lazy Fuel)

partial
forever : Fuel
forever = More forever

run : Fuel -> Vect height Integer -> StackIO height -> IO ()
run (More fuel) stk (Do c f)
     = do (res, newStk) <- runStack stk c
          run fuel newStk (f res)
run Dry stk p = pure ()

doAdd : StackCmd () (S (S height)) (S height)
doAdd = do val1 <- Pop
           val2 <- Pop
           Push (val1 + val2)

doSubtract : StackCmd () (S (S height)) (S height)
doSubtract = do val1 <- Pop
                val2 <- Pop
                Push (val1 - val2)

doMultiply : StackCmd () (S (S height)) (S height)
doMultiply = do val1 <- Pop
                val2 <- Pop
                Push (val1 * val2)

doNegate : StackCmd () (S height) (S height)
doNegate = do val1 <- Pop
              Push (-val1)

mutual
  tryAdd : StackIO height
  tryAdd {height = (S (S h))} = do doAdd
                                   result <- Top
                                   PutStr (show result ++ "\n")
                                   stackCalc
  tryAdd = do PutStr "Fewer than two items on the stack\n"
              stackCalc

  trySubtract : StackIO height
  trySubtract {height = (S (S h))} = do doSubtract
                                        result <- Top
                                        PutStr (show result ++ "\n")
                                        stackCalc
  trySubtract = do PutStr "Fewer than two items on the stack\n"
                   stackCalc

  tryMultiply : StackIO height
  tryMultiply {height = (S (S h))} = do doMultiply
                                        result <- Top
                                        PutStr (show result ++ "\n")
                                        stackCalc
  tryMultiply = do PutStr "Fewer than two items on the stack\n"
                   stackCalc

  tryNegate : StackIO height
  tryNegate {height = (S h)} = do doNegate
                                  result <- Top
                                  PutStr (show result ++ "\n")
                                  stackCalc
  tryNegate = do PutStr "Fewer than one item on the stack\n"
                 stackCalc

  tryDiscard : StackIO height
  tryDiscard {height = (S h)} = do result <- Top
                                   PutStr ("Discarded " ++ show result ++ "\n")
                                   stackCalc
  tryDiscard = do PutStr "Fewer than one item on the stack\n"
                  stackCalc

  tryDuplicate : StackIO height
  tryDuplicate {height = (S h)} = do val <- Top
                                     Push val
                                     PutStr ("Duplicated " ++ show val ++ "\n")
                                     stackCalc
  tryDuplicate = do PutStr "Fewer than one item on the stack\n"
                    stackCalc

  data StkInput = Number Integer
                | Add
                | Subtract
                | Multiply
                | Negate
                | Discard
                | Duplicate

  strToInput : String -> Maybe StkInput
  strToInput "" = Nothing
  strToInput "add" = Just Add
  strToInput "subtract" = Just Subtract
  strToInput "multiply" = Just Multiply
  strToInput "negate" = Just Negate
  strToInput "discard" = Just Discard
  strToInput "duplicate" = Just Duplicate
  strToInput x = if all isDigit (unpack x)
                    then Just (Number (cast x))
                    else Nothing

  stackCalc : StackIO height
  stackCalc = do PutStr "> "
                 input <- GetStr
                 case strToInput input of
                      Nothing => do PutStr "Invalid input\n"
                                    stackCalc
                      Just (Number x) => do Push x
                                            stackCalc
                      Just Add => tryAdd
                      Just Subtract => trySubtract
                      Just Multiply => tryMultiply
                      Just Negate => tryNegate
                      Just Discard => tryDiscard
                      Just Duplicate => tryDuplicate

main : IO ()
main = run forever [] stackCalc


-- Page 389

-- Exercise 1
namespace p389_ex1

  data Access = LoggedOut | LoggedIn
  data PwdCheck = Correct | Incorrect

  data ShellCmd : (ty : Type) -> Access -> (ty -> Access) -> Type where
      Password : String -> ShellCmd PwdCheck LoggedOut
          (\check => case check of
                     Correct => LoggedIn
                     Incorrect => LoggedOut)
      Logout : ShellCmd () LoggedIn (const LoggedOut)
      GetSecret : ShellCmd String LoggedIn (const LoggedIn)

      PutStr : String -> ShellCmd () state (const state)
      Pure : (res : ty) -> ShellCmd ty (stateFn res) stateFn
      (>>=) : ShellCmd a state1 state2Fn ->
              ((res : a) -> ShellCmd b (state2Fn res) state3Fn) ->
              ShellCmd b state1 state3Fn

  session : ShellCmd () LoggedOut (const LoggedOut)
  session = do Correct <- Password "wurzel"
               | Incorrect => PutStr "Wrong password"
               msg <- GetSecret
               PutStr ("Secret code: " ++ show msg ++ "\n")
               Logout

-- Exercise 2
-- See `Vending.idr`
