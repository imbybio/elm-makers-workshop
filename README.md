# Makers Academy Elm workshop

This repository contains the code and explanation required to follow the
Makers Academy Elm workshop given in London on 12th April 2017. The idea is
to build a very simple Elm app that produces a list of
[novels nominated for the 2017 Hugo Awards](http://www.tor.com/2017/04/04/2017-hugo-award-finalists-announced/).

## Pre-requisites

In order to follow the workshop, you need to install `Elm` and `json-server`.
To do this, first install [Node.js](https://nodejs.org/en/download/) and `npm`.
Once this is done, you can run:

    npm install -g elm
    npm install -g json-server

To check that Elm is installed, you can try to run the `repl` (^D to exit):

    elm repl

Once Elm is installed, clone this repository, navigate to the newly created
directory and download dependencies:

    elm package install

## Content

This repository contains a number of files that will be used as part of the
workshop. First, some house-keeping files:

- `README.md`: this file
- `LICENSE`: a copy of the open source license this code is released under, in
  this case the BSD3 license in keeping with the Elm defaults
- `.gitignore`: the file that tells `git` to ignore all Elm build artefacts

Then, there is the Elm package file that tells the `elm package` utility what
dependencies to download and build. This is the bare minimum you need to
define an Elm project:

- `elm-package.json`

A couple of Elm modules that will be used during the workshop:

- `Book.elm`: a module the describe a `Book` data type and associated functions
- `Mock.elm`: a module that defines mock data to get started

And finally, a database file to use with `json-server` that contains a JSON
version of `Mock.elm` and that will be used to bring up an API service:

- `hugo.json`

## Workshop

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
defined as have a field called `title`, you can safely extract the value of
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

### Create a model and display it

Let's start coding by creating a `Main.elm` file that will contain:

- a very basic model that is just a string
- a view function that displays the string
- a `Html.beginnerProgram` that wires everything together

Everything needed is in the core and html packages and you can find the
documentation online:

- [Core](http://package.elm-lang.org/packages/elm-lang/core/latest/)
- [Html](http://package.elm-lang.org/packages/elm-lang/html/latest)

Run the program by starting `elm reactor` and navigating to
[http://localhost:8000/Main.elm](http://localhost:8000/Main.elm).

### A more complicated model

Let's update the model to a data structure with a `books` field that is a list
of `Book`s, initialise it via `Mock.data` and display all books in order with
a suitable title on top. Note: the `Book` module has a `viewSummary` function
to do that for an individual book and `List.map` is your friend to do it for
all books.

### Add a control to the page

A static page is boring so let's make it interactive by adding a checkbox to
the top of the page. When that checkbox is checked, we should show full details
for each of the books, when it's unchecked, we should just show the summary for
each book. To do this, you will need to:

- add a field to the model that keeps the value of the checkbox
- change the `view` function to display the checkbox
- implement an `update` function that updates that field when the checkbox is
  clicked (use the `Html.Events` package to wire it all together)
- use the `Book.view` function rather than the `Book.viewSummary` one

### Get the data from a REST API

Using mock data is too easy so let's get it from an API instead. You can get
a suitable API up and running by starting the JSON server:

    json-server hugo.json

This will make a resource available at
[http://localhost:3000/novels](http://localhost:3000/novels) that we will need
to call from the Elm program. For this you will need to:

- use `Html.program` instead of `Html.beginnerProgram` which in turn will
  require creating an `init` function and changing the `update` function to
  return a tuple containing the new model and a command
- add the `elm-lang/http` package to `elm-package.json`, download it and import
  it so that you can use the `Http.send` and `Http.get` methods, as shown in the
  [documentation](http://package.elm-lang.org/packages/elm-lang/http/latest)
- add suitable message handling to the `update` method bearing in mind that it
  needs to handle a `Result` which can contain either the expected result or
  an error

## Beyond the workshop

Here are a few ideas of additional things to do to go beyond this workshop.

### Compile to a static file

Rather than run `elm reactor`, we can compile the app to a static `index.html`
file by running `elm make`:

    elm make Main.elm

You can then open the `index.html` file in a browser as a static file.

### Add per-book interaction

Rather than have a checkbox at the top of the page, we could have each book
entry act as an independently collapsible section that would extend or
collapse when clicking on the title. For this you will need to:

- update the `Book` type to include a state flag
- create an `update` function in the `Book` module and wire it in the
  `Book.view` function
- call the `Book.update` function from the `Main.update` one with the correct
  message

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

### Call the app from a static HTML page

One thing that Elm doesn't currently support is the use of an external CSS
style sheet. This can be fixed by creating a static `index.html` page that
includes the style sheet and starts the Elm app. You will then need to
compile the app statically to a JavaScript file:

    elm make Main.elm --output=main.js

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
