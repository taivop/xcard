

-- http://book.realworldhaskell.org/read/using-typeclasses.html
main
    = do
        sisu <- readFile "sample.xcards"
        let f2 = (read sisu)::File
        return f2
        
        
        
        
        
        
        
-- fail on list kolmikutest
data File
    = Fail [(String, Int, CardType)]
    deriving (Show, Read)
    
-- on kahte tüüpi kaarte: olendid ja loitsud
data CardType
    = MinionCard [Effect] Int Int Bool (Maybe MinionType)
    | SpellCard [Effect]
    deriving (Show, Read)
    
-- olenditel võivad olla sellised tüübid    
data MinionType
    = Beast
    | Murloc
    deriving (Show, Read)
    
data Effect
    = OnPlay [EventEffect]              -- efekt kaardi käimisel
    | UntilDeath [EventEffect]          -- efekt, mis kestab välja käimisest kuni olendi surmani
    | OnDamage [EventEffect]            -- efekt, mis tehakse olendi vigastamisel
    | OnDeath [EventEffect]             -- efekt, mis tehakse olendi tapmisel (elupunktid <= 0)
    deriving (Show, Read)

-- toime on kaardi võtmine või olendite mõjutamine --- vastavalt filtrile    
data EventEffect
    = All [Filter] [CreatureEffect]     -- mõjutatakse kõiki filtrile vastavaid olendeid
    | Choose [Filter] [CreatureEffect]  -- mõjutatakse üht kasutaja valitud filtrile vastavat olendeit
    | Random [Filter] [CreatureEffect]  -- mõjutatakse üht juhuslikku filtrile vastavat olendeit
    | DrawCard                          -- toime olendi omanik võtab kaardi
    deriving (Show, Read)

data CreatureEffect
    = Health Type Int                -- elupunktide muutmine
    | Attack Type Int                -- ründepunktide muutmine
    | Taunt Bool                     -- mõnituse muutmine
    deriving (Show, Read)
    
-- muutuse tüüp
data Type
    = Relative                          -- negatiivne relatiivne muutmine on vigastamine 
    | Absolute                          -- absoluutne negatiivne muutmine ei ole vigastamine
    deriving (Show, Read)

-- filtri list on konjunktsioon, välja arvatud "Any" puhul    
data Filter
    = AnyCreature                       -- olendid
    | AnyHero                           -- kangelased
    | AnyFriendly                       -- "omad"    
    | Type MinionType                   -- kindlat tüüpi olendid
    | Self                              -- mõjutav olend ise
    | Not [Filter]                      -- eitus
    | Any [Filter]                      -- disjunktsioon
    deriving (Show, Read)