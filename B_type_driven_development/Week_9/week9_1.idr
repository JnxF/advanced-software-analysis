import Data.Vect
import Control.Monad.State

-- Page 332

-- Exercise 1
update : (stateType -> stateType) -> State stateType ()
update f = do current <- get
              put (f current)

-- Exercise 2
data Tree a = Empty | Node (Tree a) a (Tree a)

testTree : Tree String
testTree = Node (Node (Node Empty "Jim" Empty) "Fred"
                     (Node Empty "Sheila" Empty)) "Alice"
               (Node Empty "Bob" (Node Empty "Eve" Empty))

countEmpty : Tree a -> State Nat ()
countEmpty Empty = do
  current <- get
  put (S current)

countEmpty (Node left val right) = do
  countEmpty left
  countEmpty right

-- Exercise 3
countEmptyNode : Tree a -> State (Nat, Nat) ()
countEmptyNode Empty = do
  (empties, nodes) <- get
  put (S empties, nodes)
countEmptyNode (Node left val right) = do
  countEmptyNode left
  (empties, nodes) <- get
  put (empties, S nodes)
  countEmptyNode right


-- Page 350
record Score where
       constructor MkScore
       correct : Nat
       attempted : Nat

record GameState where
       constructor MkGameState
       score : Score
       difficulty : Int

initState : GameState
initState = MkGameState (MkScore 0 0) 12

data Command : Type -> Type where
  PutStr : String -> Command ()
  GetLine : Command String

  GetRandom : Command Int
  GetGameState : Command GameState
  PutGameState : GameState -> Command ()

  Pure : ty -> Command ty
  Bind : Command a -> (a -> Command b) -> Command b


-- Exercise 1


-- Exercise 2
mutual
  Functor Command where
    map func x = do x' <- x
                    pure (func x')

  Applicative Command where
    pure = Pure
    (<*>) f x = do f' <- f
                   x' <- x
                   Pure (f' x')

  Monad Command where
    (>>=) = Bind

-- Exercise 3
record Votes where
      constructor MkVotes
      upvotes : Integer
      downvotes : Integer

record Article where
      constructor MkArticle
      title : String
      url : String
      score : Votes

initPage : (title : String) -> (url : String) -> Article
initPage title url = MkArticle title url (MkVotes 0 0)

getScore : Article -> Integer
getScore (MkArticle title url (MkVotes upvotes downvotes)) = upvotes - downvotes

badSite : Article
badSite = MkArticle "Bad Page" "http://example.com/bad" (MkVotes 5 47)
goodSite : Article
goodSite = MkArticle "Good Page" "http://example.com/good" (MkVotes 101 7)

-- Exercise 4
addUpvote : Article -> Article
addUpvote (MkArticle title url (MkVotes upvotes downvotes)) =
  (MkArticle title url (MkVotes (upvotes + 1) downvotes))

addDownvote : Article -> Article
addDownvote (MkArticle title url (MkVotes upvotes downvotes)) =
  (MkArticle title url (MkVotes upvotes (downvotes + 1)))


-- Page 362

-- Exercise 1
{-
data DoorState = DoorClosed | DoorOpen

data DoorCmd : Type -> DoorState -> DoorState -> Type where
  Open : DoorCmd     () DoorClosed DoorOpen
  Close : DoorCmd    () DoorOpen   DoorClosed
  RingBell : DoorCmd () DoorClosed DoorClosed

  -- Pure : ty -> DoorCmd ty state state
  (>>=) : DoorCmd a state1 state2
          -> (a -> DoorCmd b state2 state3)
          -> DoorCmd b state1 state3



doorProg : DoorCmd () DoorClosed DoorClosed
doorProg = do RingBell
              Open
              RingBell
              Close
-}

-- Exercise 2

-- Exercise 3
data Matter = Solid | Liquid | Gas

data MatterCmd : Type -> Matter -> Matter -> Type where
  Melt :     MatterCmd () Solid  Liquid
  Boil :     MatterCmd () Liquid Gas
  Condense : MatterCmd () Gas    Liquid
  Freeze :   MatterCmd () Liquid Solid

  Pure : ty -> MatterCmd ty state state

--iceSteam : MatterCmd () Solid Gas
--iceSteam = do Melt
--              Boil
