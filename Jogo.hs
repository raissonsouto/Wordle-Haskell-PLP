module Jogo where

    import System.IO
    import ColorfulPrint
    import GuessChecker
    import Data.Char (isLetter, toLower)

    toLowerString :: [Char] -> [Char]
    toLowerString str = [ toLower x | x <- str]
    
    checkInputLength::String->Bool
    checkInputLength texto = do
        length texto /= 5
    
    append :: String -> [String] -> [String]
    append a [] = [a]
    append a (x:xs) = x : append a xs
    
    jogo::[String]->[String]->Int->IO()
    jogo tentativas metadados recursao = do
    
        newGuess <- getLine
        if checkInputLength newGuess
        then do
            putStr "Palavra com tamanho errado. Tente novamente: "
            hFlush stdout
            jogo tentativas metadados recursao
        else do
            let newTentativas = append newGuess tentativas
            let metadado = guessChecker  newGuess "teste" --selectWord
            let newMetadados = append metadado metadados

            putStrLn (colorfulPrint newTentativas newMetadados)
            
            if metadado == "VVVVV" then putStrLn "Voce ganhou!"
            else if recursao > 3 then putStrLn "Você perdeu!"
            else jogo tentativas metadados (recursao+1)
