{-# LANGUAGE DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
module User where
  import qualified Data.ByteString.Lazy as B
  import GHC.Generics
  import Data.Text (Text)
  import Data.Aeson
  import Data.Text.Unsafe (unsafeDupablePerformIO)
  import Data.Text.Lazy.IO as I
  import Data.Aeson.Text (encodeToLazyText)
  import Data.Text (pack)

  jsonFile :: FilePath
  jsonFile = "User.json"

  getJSON :: IO B.ByteString
  getJSON = B.readFile jsonFile

  data User =
    User { username                           ::Text
          , qtdTentativas                    ::Int
          , qtdDeVitorias                    ::Int
          , sequenciaDeVitorias              ::Int
          , maiorSequenciaDeVitorias         ::Int
          , distribuicaoDeTentativasCorretas ::[Int]
            } deriving (Show, Generic, Read)

  instance FromJSON User
  instance ToJSON User

  getUsers::IO [User]
  getUsers = do
      d <- (eitherDecode <$> getJSON) :: IO (Either String [User])
      case d of
          Left err -> return []
          Right ps -> return ps

  isUserRegistered :: String -> IO Bool
  isUserRegistered usuario = do
      u <- getUsers
      let users =  u
      let res =  filter (\x -> "\"" ++ usuario ++ "\"" ==  show (username x)) users
      return (not (null res))


  getStats::String-> IO [Int]
  getStats usuario = do
      u <- getUsers
      let users =  u
      let res =  filter (\x -> "\"" ++ usuario ++ "\"" ==  show (username x)) users
      return (distribuicaoDeTentativasCorretas (head res))


  showStats::[Int]->IO()
  showStats stats = do
      Prelude.putStrLn ("1a tentativa: " ++  show (head stats))
      Prelude.putStrLn ("2a tentativa: " ++  show (stats !! 1))
      Prelude.putStrLn ("3a tentativa: " ++  show (stats !! 2))
      Prelude.putStrLn ("4a tentativa: " ++  show (stats !! 3))
      Prelude.putStrLn ("5a tentativa: " ++  show (stats !! 4))
      Prelude.putStrLn ("6a tentativa: " ++  show (stats !! 5))



  createUser :: String -> User
  createUser usuario = user
      where user = User{username= pack usuario
          , qtdTentativas=0
          , qtdDeVitorias=0
          , sequenciaDeVitorias=0
          , maiorSequenciaDeVitorias=0
          , distribuicaoDeTentativasCorretas=[0,0,0,0,0,0,0]}


  addUser::String->IO Bool
  addUser usuario = do
      r <- isUserRegistered usuario
      u <- getUsers
      if not r then
          I.writeFile jsonFile (encodeToLazyText (u ++ [createUser usuario]))
      else
          I.writeFile jsonFile (encodeToLazyText u)
      return (not r)