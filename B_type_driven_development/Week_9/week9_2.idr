-- Page 371

-- Exercise 1

-- Exercise 2

-- Exercise 3

-- Exercise 4


-- Page 389

-- Exercise 1
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
