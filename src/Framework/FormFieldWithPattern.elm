module Framework.FormFieldWithPattern exposing
    ( inputText
    , introspection, example1, example2, example3, Field(..), Model, Msg, initModel, update
    )

{-| [Demo](https://lucamug.github.io/style-framework/generated-framework.html#/framework/Fields%20With%20Patterns/Phone%20number%20USA)

[![Fields with patterns](https://lucamug.github.io/style-framework/images/demos/fields-with-patterns.png)](https://lucamug.github.io/style-framework/generated-framework.html#/framework/Fields%20With%20Patterns/Phone%20number%20USA)


# Input fields

@docs inputText


# Introspection

Used internally to generate the [Style Guide](https://lucamug.github.io/)

@docs introspection, example1, example2, example3, Field, Model, Msg, initModel, update

-}

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Framework.Color
import Framework.Configuration exposing (conf)
import Html.Attributes
import Regex


{-| -}
type alias Model =
    { value : String
    , focus : Maybe Field
    }


{-| -}
initModel : Model
initModel =
    { value = ""
    , focus = Nothing
    }


{-| -}
type Field
    = FieldTelephone
    | FieldCreditCard
    | Field6DigitCode


{-| -}
type Msg
    = Input Field String String
    | OnFocus Field
    | OnLoseFocus Field


regexNotDigit : Regex.Regex
regexNotDigit =
    Maybe.withDefault Regex.never (Regex.fromString "[^0-9]")


regexNotDigitsAtTheEnd : Regex.Regex
regexNotDigitsAtTheEnd =
    Maybe.withDefault Regex.never (Regex.fromString "[^0-9]*$")


{-| -}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input field pattern value ->
            let
                onlyDigits =
                    Regex.replace regexNotDigit (\_ -> "") value

                withPattern =
                    result pattern onlyDigits

                removeCharactedAtTheEndIfNotNumbers =
                    Regex.replace regexNotDigitsAtTheEnd (\_ -> "") withPattern
            in
            ( case field of
                FieldTelephone ->
                    { model | value = removeCharactedAtTheEndIfNotNumbers }

                FieldCreditCard ->
                    { model | value = removeCharactedAtTheEndIfNotNumbers }

                Field6DigitCode ->
                    { model | value = removeCharactedAtTheEndIfNotNumbers }
            , Cmd.none
            )

        OnFocus field ->
            ( { model | focus = Just field }, Cmd.none )

        OnLoseFocus _ ->
            ( { model | focus = Nothing }, Cmd.none )


{-| -}
introspection :
    { name : String
    , description : String
    , signature : String
    , variations : List ( String, List ( Element msg1, String ) )
    }
introspection =
    { name = "Fields With Patterns"
    , description = "List of elements for Web Forms"
    , signature = ""
    , variations =
        [ ( "Phone number USA", [ ( text "special: FormFieldWithPattern.example1", "" ) ] )
        , ( "Credit Card number", [ ( text "special: FormFieldWithPattern.example2", "" ) ] )
        , ( "6 Digit Code", [ ( text "special: FormFieldWithPattern.example3", "" ) ] )
        ]
    }


hasFocus : Model -> Field -> Bool
hasFocus model field =
    case model.focus of
        Just focus ->
            focus == field

        Nothing ->
            False


hackInLineStyle : String -> String -> Attribute msg
hackInLineStyle text1 text2 =
    Element.htmlAttribute (Html.Attributes.style text1 text2)


{-| -}
example1 : Model -> ( Element Msg, String )
example1 model =
    ( inputText model
        { field = FieldTelephone
        , pattern = "(000) 000 - 0000"
        , label = "Phone number USA"
        , id = "test"
        }
    , """inputText model
    { field = FieldTelephone
    , pattern = "(000) 000 - 0000"
    , label = "Phone number USA"
    , id = "test"
    }"""
    )


{-| -}
example2 : Model -> ( Element Msg, String )
example2 model =
    ( inputText model
        { field = FieldCreditCard
        , pattern = "0000 - 0000 - 0000 - 0000"
        , label = "Credit Card number"
        , id = "test"
        }
    , """inputText model
    { field = FieldCreditCard
    , pattern = "0000 - 0000 - 0000 - 0000"
    , label = "Credit Card number"
    , id = "test"
    }"""
    )


{-| -}
example3 : Model -> ( Element Msg, String )
example3 model =
    ( inputText model
        { field = Field6DigitCode
        , pattern = "______"
        , label = "6 Digits Code"
        , id = "test"
        }
    , """inputText model
    { field = Field6DigitCode
    , pattern = "______"
    , label = "6 Digits Code"
    , id = "test"
    }"""
    )


{-| -}
inputText : Model -> { a | id : String, field : Field, label : String, pattern : String } -> Element Msg
inputText model { id, field, pattern, label } =
    let
        lengthDifference =
            String.length pattern - String.length modelValue

        patternToShow =
            modelValue ++ String.right lengthDifference pattern

        largeSize =
            field == Field6DigitCode

        letterSpacing =
            if largeSize then
                "10px"

            else
                "1px"

        font =
            if largeSize then
                [ Font.family
                    [ Font.monospace
                    ]
                , Font.size 54
                ]

            else
                []

        moveDownPlaceHolder =
            if largeSize then
                9

            else
                11

        modelValue =
            case field of
                FieldTelephone ->
                    model.value

                FieldCreditCard ->
                    model.value

                Field6DigitCode ->
                    model.value

        labelIsAbove =
            hasFocus model field || modelValue /= "" || largeSize
    in
    el
        []
    <|
        Input.text
            ([ Events.onFocus <| OnFocus field
             , Events.onLoseFocus <| OnLoseFocus field
             , Background.color <| Element.rgba 0 0 0 0
             , if largeSize then
                Border.width 0

               else
                Border.widthEach { bottom = 2, left = 0, right = 0, top = 0 }
             , hackInLineStyle "letter-spacing" letterSpacing
             , Border.rounded 0
             , paddingXY 0 8
             , width fill
             , hackInLineStyle "transition" "all 0.15s"

             --, Element.htmlAttribute <| Html.Attributes.id "elementToFocus"
             , behindContent <|
                el
                    ([ if hasFocus model field && largeSize then
                        Font.color Framework.Color.primary

                       else
                        Font.color Framework.Color.grey_light
                     , moveDown moveDownPlaceHolder
                     , hackInLineStyle "pointer-events" "none"
                     , hackInLineStyle "letter-spacing" letterSpacing
                     ]
                        ++ font
                    )
                <|
                    text <|
                        if labelIsAbove then
                            patternToShow

                        else
                            ""
             ]
                ++ font
                ++ (if hasFocus model field then
                        [ Border.color Framework.Color.primary ]

                    else
                        []
                   )
            )
            { label =
                Input.labelAbove
                    ([ hackInLineStyle "transition" "all 0.15s"
                     , hackInLineStyle "pointer-events" "none"
                     , Font.family [ Font.typeface conf.font.typeface, conf.font.typefaceFallback ]
                     , Font.size 16
                     ]
                        ++ (if labelIsAbove then
                                []

                            else
                                [ moveDown 33 ]
                           )
                    )
                <|
                    text label
            , onChange = Input field pattern
            , placeholder = Nothing
            , text = modelValue
            }



-- Internal


type Token
    = InputValue
    | Other Char


parse : Char -> String -> List Token
parse inputChar pattern =
    String.toList pattern
        |> List.map (tokenize inputChar)


tokenize : Char -> Char -> Token
tokenize inputChar pattern =
    if pattern == inputChar || pattern == '_' then
        InputValue

    else
        Other pattern


format : List Token -> String -> String
format tokens input =
    if String.isEmpty input then
        input

    else
        append tokens (String.toList input) ""


result : String -> String -> String
result template string =
    format (parse '0' template) string


append : List Token -> List Char -> String -> String
append tokens input formatted =
    let
        appendInput =
            List.head input
                |> Maybe.map (\char -> formatted ++ String.fromChar char)
                |> Maybe.map (append (Maybe.withDefault [] (List.tail tokens)) (Maybe.withDefault [] (List.tail input)))
                |> Maybe.withDefault formatted

        maybeToken =
            List.head tokens
    in
    case maybeToken of
        Nothing ->
            formatted

        Just token ->
            case token of
                InputValue ->
                    appendInput

                Other char ->
                    append (Maybe.withDefault [] <| List.tail tokens) input (formatted ++ String.fromChar char)
