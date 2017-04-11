module Book exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (class, src, style)
import Json.Decode as Decode exposing (Decoder)


type alias Book =
    { isbn : String
    , title : String
    , authors : List String
    , description : String
    , thumbnail : String
    }


decoder : Decoder Book
decoder =
    Decode.map5 Book
        (Decode.field "isbn" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "authors" (Decode.list Decode.string))
        (Decode.field "description" Decode.string)
        (Decode.field "thumbnail" Decode.string)


viewSummary : Book -> Html msg
viewSummary =
    view False


view : Bool -> Book -> Html msg
view full book =
    Html.div
        [ class "book"
        , style
            [ ( "clear", "both" )
            ]
        ]
        [ Html.div []
            [ Html.h2 [ class "title" ] [ Html.text book.title ]
            , Html.p [ class "author" ] [ Html.text (String.join ", " book.authors) ]
            ]
        , (if full then
            Html.div []
                [ Html.img
                    [ class "cover"
                    , src book.thumbnail
                    , style
                        [ ( "float", "left" )
                        ]
                    ]
                    []
                , Html.p [ class "description" ] [ Html.text book.description ]
                ]
           else
            Html.text ""
          )
        ]
