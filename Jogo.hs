module Jogo where

    import System.IO
    import ColorfulPrint
    import GuessChecker
    import Data.Char (isLetter, toLower)
    
    checkInputLength::String->Bool
    checkInputLength texto = do
        length texto /= 5
    
    append :: String -> [String] -> [String]
    append a [] = [a]
    append a (x:xs) = x : append a xs
    
    jogo::[String]->[String]->String->Int->IO Int
    jogo tentativas metadados palavraEscolhida recursao = do
        putStr("\n  Qual a palavra secreta? ")
        hFlush stdout
        newGuess <- getLine
        if checkInputLength newGuess
        then do
            putStr "Palavra com tamanho errado. Tente novamente: "
            hFlush stdout
            jogo tentativas metadados palavraEscolhida recursao
        else do
            let newTentativas = append newGuess tentativas
            let metadado = guessChecker  newGuess palavraEscolhida
            let newMetadados = append metadado metadados

            putStrLn (colorfulPrint newTentativas newMetadados)
            
            if metadado == "VVVVV" then do
                winMessage
                putStrLn ("Parabéns! A palavra secreta é: " ++ (textColorizer palavraEscolhida "VVVVV" 0))
                return (recursao)

            else if recursao > 4 then  do
                loseMessage
                putStrLn ("Tente outra vez. A palavra secreta é: " ++ (textColorizer palavraEscolhida "VVVVV" 0))
                return (recursao+1)

            else jogo newTentativas newMetadados palavraEscolhida (recursao+1)

    winMessage:: IO()
    winMessage = do
        putStrLn ("######################################################################\n"                                                                    
            ++"#                                                                    #\n"
            ++"#        ██╗   ██╗ ██████╗ ██╗   ██╗     ██╗    ██╗██╗███╗   ██╗     #\n" 
            ++"#        ╚██╗ ██╔╝██╔═══██╗██║   ██║     ██║    ██║██║████╗  ██║     #\n"
            ++"#         ╚████╔╝ ██║   ██║██║   ██║     ██║ █╗ ██║██║██╔██╗ ██║     #\n"
            ++"#          ╚██╔╝  ██║   ██║██║   ██║     ██║███╗██║██║██║╚██╗██║     #\n"
            ++"#           ██║   ╚██████╔╝╚██████╔╝     ╚███╔███╔╝██║██║ ╚████║     #\n"    
            ++"#           ╚═╝    ╚═════╝  ╚═════╝       ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝     #\n"
            ++"#                                                                    #\n"
            ++"######################################################################\n")
    
    loseMessage:: IO()
    loseMessage = do
        putStrLn ("###############################################################################\n"
            ++"#                                                                             #\n"
            ++"#        ██╗   ██╗ ██████╗ ██╗   ██╗    ██╗      ██████╗ ███████╗███████╗     #\n"
            ++"#        ╚██╗ ██╔╝██╔═══██╗██║   ██║    ██║     ██╔═══██╗██╔════╝██╔════╝     #\n"
            ++"#         ╚████╔╝ ██║   ██║██║   ██║    ██║     ██║   ██║███████╗█████╗       #\n"
            ++"#          ╚██╔╝  ██║   ██║██║   ██║    ██║     ██║   ██║╚════██║██╔══╝       #\n"
            ++"#           ██║   ╚██████╔╝╚██████╔╝    ███████╗╚██████╔╝███████║███████╗     #\n"
            ++"#           ╚═╝    ╚═════╝  ╚═════╝     ╚══════╝ ╚═════╝ ╚══════╝╚══════╝     #\n"
            ++"#                                                                             #\n"
            ++"###############################################################################\n")
