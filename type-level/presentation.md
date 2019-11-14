---
author: "Jonathan Lorimer"
title: "Intro To Type Level Programming"
patat:
    wrap: true
    incrementalLists: true
    theme:
        header: [bold, dullYellow]
        bulletList: [dullWhite, dullWhite]
        emph: [bold]
        strong: [bold]
        code: [vividRed, onDullWhite, bold]
        codeBlock: [dullWhite, onDullBlack ]
        syntaxHighlighting:
          string: [dullGreen]
          char: [dullGreen]
          specialChar: [dullCyan]
          verbatimString: [dullGreen]
---

# What is type level programming?
- Executing logic statically; at compile time / coding time
- Constrains the possible states of our program
- Has no runtime representation
    - Strictly speaking this isn't true, but for our purposes we will act as if it is
- Turning runtime errors into compile time errors

## All type, no term

- Empty data declarations `-XEmptyDataDecls` was introduced in Haskell2010
- It is a type declaration with no co-responding data constructor; a type with no term level representation

```haskell
data Zero
data Succ n
```

## Phantom type

```haskell
data Proxy t = Proxy
```
- Allows us to use information at the type level that doesn't exist at the term level

```haskell
newtype Vec n a = MkVec [a]
```
- This is a more practical example

# Let's Implement: NoGADT.hs

## Enter {-# LANGUAGE GADTs #-}
- Allows us to constrain data constructors in the definition
- Provide a solution to the issue mentioned in the previous section

- GADT syntax:
```haskell
data Vec :: Type -> Type -> Type where
  Nil :: Vec Zero a
  (:*) :: a -> Vec n a -> Vec (Succ n) a

data Maybe :: Type -> Type where
  Nothing :: Maybe a
  Just    :: a -> Maybe a
```

# Let's Implement: GADTs.hs

## {-# LANGUAGE DataKinds #-}

- Data Kinds: Allows for promotions from the term to the type level and from the type to the kind level

```haskell
data Nat = Zero | Succ Nat
```

- All promoted Data Types are uninhabited i.e. `'Zero` has no term level representation
- the tick in `'Zero` is only necessary when there is a namespace collision, in the absence of ambiguity the tick can be ellided

```haskell
data Vec :: Nat -> Type -> Type where
  Nil :: Vec 'Zero a
  (:*) :: a -> Vec n a -> Vec ('Succ n) a
```

- `strange` should not type check now because `Vec Char Int` has the wrong kind `Type -> Type -> Type` instead of `Nat -> Type -> Type`
