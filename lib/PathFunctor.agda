{-# OPTIONS --without-K #-}

open import lib.Base
open import lib.PathGroupoid

module lib.PathFunctor {i} {A : Type i} where

{- Nondependent stuff -}
module _ {j} {B : Type j} (f : A → B) where

  !-ap : {x y : A} (p : x == y)
    → ! (ap f p) == ap f (! p)
  !-ap idp = idp

  ap-! : {x y : A} (p : x == y)
    → ap f (! p) == ! (ap f p)
  ap-! idp = idp

  ∙-ap : {x y z : A} (p : x == y) (q : y == z)
    → ap f p ∙ ap f q == ap f (p ∙ q)
  ∙-ap idp idp = idp

  ap-∙ : {x y z : A} (p : x == y) (q : y == z)
    → ap f (p ∙ q) == ap f p ∙ ap f q
  ap-∙ idp idp = idp

  ∙'-ap : {x y z : A} (p : x == y) (q : y == z)
    → ap f p ∙' ap f q == ap f (p ∙' q)
  ∙'-ap idp idp = idp

  ap-∙' : {x y z : A} (p : x == y) (q : y == z)
    → ap f (p ∙' q) == ap f p ∙' ap f q
  ap-∙' idp idp = idp

{- Dependent stuff -}
module _ {j} {B : A → Type j} (f : Π A B) where

  apd-∙ : {x y z : A} (p : x == y) (q : y == z)
    → apd f (p ∙ q) == apd f p ∙dep apd f q
  apd-∙ idp idp = idp

  apd-∙' : {x y z : A} (p : x == y) (q : y == z)
    → apd f (p ∙' q) == apd f p ∙'dep apd f q
  apd-∙' idp idp = idp

{- Fuse and unfuse -}

∘-ap : ∀ {j k} {B : Type j} {C : Type k} (g : B → C) (f : A → B)
  {x y : A} (p : x == y) → ap g (ap f p) == ap (g ∘ f) p
∘-ap f g idp = idp

ap-∘ : ∀ {j k} {B : Type j} {C : Type k} (g : B → C) (f : A → B)
  {x y : A} (p : x == y) → ap (g ∘ f) p == ap g (ap f p)
ap-∘ f g idp = idp

ap-cst : ∀ {j} {B : Type j} (b : B) {x y : A} (p : x == y)
  → ap (cst b) p == idp
ap-cst b idp = idp

ap-idf : {u v : A} (p : u == v) → ap (idf A) p == p
ap-idf idp = idp

{- Naturality of homotopies -}

htpy-natural : ∀ {j} {B : Type j} {x y : A} {f g : A → B} 
  (p : ∀ x → (f x == g x)) (q : x == y) → ap f q ∙ p y == p x ∙ ap g q
htpy-natural p idp = ! (∙-unit-r _)

htpy-natural-toid : {f : A → A}
  (p : ∀ (x : A) → f x == x) → (∀ x → ap f (p x) == p (f x))
htpy-natural-toid {f = f} p x = anti-whisker-right (p x) $ 
  htpy-natural p (p x) ∙ ap (λ q → p (f x) ∙ q) (ap-idf (p x))

-- unsure where this belongs
trans-pathfrom : ∀ {i} {A : Type i} {a x y : A} (p : x == y) (q : a == x)
  → transport (λ x → a == x) p q == q ∙ p
trans-pathfrom idp q = ! (∙-unit-r q)  
