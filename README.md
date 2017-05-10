# Makers Academy Elm workshop

This repository contains the explanations required to follow the
Makers Academy Elm workshop given in London on 10th May 2017. The idea is
to build a very simple 'hello world' Elm app.

This tutorial is released under a [CC-BY](https://creativecommons.org/licenses/by/4.0/)
license so feel free to update and share it as you wish.

## Pre-requisites

There are no pre-requisites for this workshop as everything will be done in
a web browser.

## Introduction

### Why is Elm different?

If you're used to JavaScript or Ruby, Elm will feel different, in particular,
Elm is:

- functional,
- strongly typed.

#### Functional

In Object Oriented languages like JavaScript or Ruby, you define data structures
(classes) that combine internal data fields and operations that can be applied
to those data structures. You then manipulate and modify instances of those
data structures by calling operations that apply to them. Each time you do this,
the object mutate, i.e. its internal state changes.

In Functional languages like Elm, you define data structures and operations
separately. Data structures are passed as parameters to those operations that
return modified copies. The original data structure does not change.

#### Strongly typed

Each data structure in Elm has a type and the compiler checks that each time
you pass a variable to a function, the type of this variable matches what the
function expects to receive. If not, compilation will fail and you won't be
able to run your programme.

This may sound cumbersome but it prevents a whole class of bugs that more
flexible languages can be prone to. For example, if you have a data type that is
defined as having a field called `title`, you can safely extract the value of
the `title` field out of any data structure of that type, this will never result
in an exception.

### The Elm model-view-update loop

Elm is more than a language, it also comes with a full framework that uses a
model-view-update loop. Basically, every Elm program follows this pattern:

                       msg
    model ----> view -------> update
      ^                         |
      |                         |
      +-------------------------+

It starts with a data model, this model is passed to the `view` function that
displays the data. Every time the user interacts with the view, such as
clicking on a button, this generates a message and the `update` function is
called and passed the message and the model and returns an updated model that
is fed back to the `view` function.

More advanced functionality can be added through subscriptions and commands but
the core loop stays the same.

### Syntax

The basic Elm syntax is simple:

- module and type names start with an uppercase letter, such as `Html` or `String`;
  note that by convention, a lot of modules define a type of the same name
- variable, function and parameterised type names start with a lowercase letter,
  such as `view` or `model`
- a function is called by just referencing it followed by its arguments, such as
  `view model`, and can be enclosed in braces when grouping is necessary, such
  as `(view model)`.
- lists are defined with square brackets: `[1, 2, 3]` and all items in the list
  need to be of the same type
- records are defined with curly brackets: `{ name = "Bob", age = 23 }` and
  each field can have its own type
- constant and function declarations both start with an optional type
  definition followed by an implementation:

```elm
defaultModel : String
defaultModel = "Hello world!"

view : String -> Html Msg
view model = Html.text model

update : Msg -> String -> String
update msg model = model
```

### Data types

#### Union types

Elm types are [union types](https://guide.elm-lang.org/types/union_types.html)
that make it possible to define data with variable shape. They are declared as
a list of possible shapes:

```elm
type Msg
    = SayGoodbye
    | Say String
```

The example above defines a type that can take two forms:

- the `SayGoodbye` form that is a simple marker with no additional data
- the `Say` form that is a marker followed by a `String` that carries
  additional data

As a side effect, each form declares a constructor function of the same name
so you can create values of those types by calling those constructors:

```elm
goodbye = SayGoodbye

hello = Say "Hello"
```

#### Record types aka type aliases

Elm has the concept of records, structures with named fields equivalent to
JavaScript objects, such as:

```elm
{ key : String
, value : String
}
```

However, this would be very cumbersome to type all the time so Elm provides
type aliases to make it simpler to use:

```elm
type alias KeyValuePair =
    { key : String
    , value : String
    }
```

As a side effect, it declares a constructor function of the same name as the
type alias so you can create an instance of this type in one of two ways:

```elm
kv1 =
    { key = "one"
    , value = "un"
    }

kv2 = KeyValuePair "two" "deux"
```

#### Parameterised types

Type annotations can be parmeterised to make them flexible and re-usable. For
instance, we could parameterise the `KeyValuePair` type above:

```elm
type alias KeyValuePair a =
    { key: String
    , value : a
    }
```

`a` is the parameterised type and is then specified by code that creates
instances of that type:

```elm
kv1 : KeyValuePair String
kv1 =
    { key = "one"
    , value = "un"
    }

kv2 : KeyValuePair Int
kv2 = KeyValuePair "two" 2
```

## Worksheet

### Ellie and a first Elm app

We are going to use the Ellie web app for this tutorial. Ellie is a web based
Elm editor and compiler, which you can find at: [https://ellie-app.com/](https://ellie-app.com/)

When you first open Ellie, you will see a very simple app. To see what it does,
just click the `Compile` button and the result will appear in the right hand side
of the screen. The default code does 3 things:

- it declares a `Main` module:

```elm
module Main exposing (..)
```

- it imports the `Html` module and exposes the `Html.Html` type as well as the
  `Html.text` function:

```elm
import Html exposing (Html, text)
```

- it declares and implements a `main` function:

```elm
main : Html a
main =
    text "Hello, World!"
```

This is very simple but not very useful as it is just a static piece of code
and doesn't implement the Elm loop mentioned above.

On the left hand side, there is a `Packages` section that shows what packages
are imported in the app, in the case `elm-lang/core` and `elm-lang/html`; you
can find their documentation online:

- [elm-lang/core](http://package.elm-lang.org/packages/elm-lang/core/latest/)
- [elm-lang/html](http://package.elm-lang.org/packages/elm-lang/html/latest)

### Start the Elm program loop

Change the Elm app to introduce the program loop using `Html.beginnerProgram`.
This function takes a single record argument with 3 fields:

```elm
{ model : model
, view : model -> Html msg
, update : msg -> model -> model
}
```

The `model` field is a simple value with a parameterised type called `model`
that will be used to initalise our model. As it's a parameterised type, we can
choose to use any type we want, in our case it will be a string set to the
value `"Hello, World!"`.

The `view` field is a function that takes one argument of type `model` and
returns a value of type `Html msg`. We will implement that function explicitly.

The `update` field is a function that takes two arguments of types `msg` and
`model` and returns a value of type `model`. We will provide a dummy value
for this.

To implement the program loop, we just need to call `Html.beginnerProgram` in
our `main` function (note that the type signature changes):

```elm
main : Program Never String msg
main = Html.beginnerProgram
    { model = "Hello, World!"
    , view = view
    , update = (\_ -> \model -> model)
    }
```

Note that update is implemented as an inline function. We also need to implement
the view function. As we decided to use the `String` type for our model, that's
what the view function needs to take as its first argument so the signature
should match. Implement the function so that the text is included in an HTML
`p` tag. Most functions in the `Html` package, and in particular the `p`
function take two arguments: a list of HTML attributes and a list of sub-tags.

### Add a button that changes the model

Change the app to include a button that changes the model to `"Goodbye, World!"`.
To do this, you will need to:

- implement a union type for the message
- implement an `update` function that will change the model depending on the
  message passed
- wire the button in the view using the `Html.Events.onClick` function

Union types are a bit like an enumeration of possible values except that each
of them can be a complex type and they are defined as follows:

```elm
type Msg
    = SayGoodbye
    | SayHello
```

In order to check what value a variable of such a type has, we can use a `case`
statement:

```elm
case msg of
    SayGoodbye -> "Goodbye, World!"
```

As we decided to use `Msg` for our message type, the first argument of the
`update` function will need to be of that type and the signatures of the
`main` and `view` functions will need to reflect this. As we decided to use
`String` for our model type, the second argument of the `update` function
will need to be of that type.

### Update the text via a text field

Another way to update the text is to take user input via a test field. To do
that, you will need to add another message that is able to take a `String` as
a parameter so that is can be used by `Html.Events.onInput` and wire that
message in the `view` function.

### Update the text on button click

With the previous implementation, the text is updated as soon as any character
is entered in the text box. Change the program so that it's only updated when
a button is clicked. You will need to:

- change the model so that it holds the text field content separately from the
  displayed text
- add a button that updates the text using the value passed in the message

## Beyond the workshop

Here are a few ideas of additional things to do to go beyond this workshop.

### Compile locally

Reproduce everything by installing the Elm compiler on your machine so that
you don't have to rely on a web app. To do that, install it via `npm`:

    npm install -g elm

You will need to create a `elm-package.json` file and install dependencies:

    elm package install

You can then move all your code into a `Main.elm` file and run it:

    elm reactor

You should then be able to see your app at
[http://localhost:8000/Main.elm](http://localhost:8000/Main.elm)

### Get data from a REST API

Get a message from a REST API and display it.

- use `Html.program` instead of `Html.beginnerProgram` which in turn will
  require creating an `init` function and changing the `update` function to
  return a tuple containing the new model and a command
- add the `elm-lang/http` package to the list of packages and import
  it so that you can use the `Http.send` and `Http.get` methods, as shown in the
  [documentation](http://package.elm-lang.org/packages/elm-lang/http/latest)
- add suitable message handling to the `update` method bearing in mind that it
  needs to handle a `Result` which can contain either the expected result or
  an error


### Unit testing

Elm has a great unit testing library. The simplest way is to install it via
`npm`:

    npm install -g elm-test

You can then create a testing skeleton:

    elm test init

This will create a `tests` directory with skeleton files in it and a `src`
directory, the idea being that your test code is all in `tests` and your app
code is all in `src`. Once done, you will need to:

- move all you app code to `src`
- update `elm-package.json` so that the `source-directories` value points to
  `src` rather than `.`
- adjust the new `tests/elm-package.json` to ensure it includes the same
  dependencies as the main one as well as the `elm-community/elm-test` and
  `rtfeldman/node-test-runner` ones

You can then run all yor unit tests by typing:

    elm test

Then write some tests by following
[the documentation](http://package.elm-lang.org/packages/elm-community/elm-test/latest)!

### Add navigation

As soon as you consider having more than one page in your app, you will need
some sort of navigation. Luckily, Elm has what you need to do that in the
form of the `elm-lang/navigation` package. To use it, you will need to:

- use `Navigation.program` rather than `Html.program`
- handle a `Navigation.Location` structure and parse the content

As ever, there is [great documentation](http://package.elm-lang.org/packages/elm-lang/navigation/latest).

### Vector graphics

Elm supports SVG out of the box via the `elm-lang/svg` package, which once
again comes with [documentation](http://package.elm-lang.org/packages/elm-lang/svg/latest)

### Explore other packages

The number of Elm packages is growing fast and you can explore the
[package library](http://package.elm-lang.org/). In particular, check out
the packages under `elm-lang` and `elm-community`.

### Go through the architecture tutorial

Elm also has an excellent [tutorial](https://guide.elm-lang.org/architecture/)
that introduces all the key concepts.
