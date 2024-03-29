

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
    
-- on kahte t��pi kaarte: olendid ja loitsud
data CardType
    = MinionCard [Effect] Int Int Bool (Maybe MinionType)
    | SpellCard [Effect]
    deriving (Show, Read)
    
-- olenditel v�ivad olla sellised t��bid    
data MinionType
    = Beast
    | Murloc
    deriving (Show, Read)
    
data Effect
    = OnPlay [EventEffect]              -- efekt kaardi k�imisel
    | UntilDeath [EventEffect]          -- efekt, mis kestab v�lja k�imisest kuni olendi surmani
    | OnDamage [EventEffect]            -- efekt, mis tehakse olendi vigastamisel
    | OnDeath [EventEffect]             -- efekt, mis tehakse olendi tapmisel (elupunktid <= 0)
    deriving (Show, Read)

-- toime on kaardi v�tmine v�i olendite m�jutamine --- vastavalt filtrile    
data EventEffect
    = All [Filter] [CreatureEffect]     -- m�jutatakse k�iki filtrile vastavaid olendeid
    | Choose [Filter] [CreatureEffect]  -- m�jutatakse �ht kasutaja valitud filtrile vastavat olendeit
    | Random [Filter] [CreatureEffect]  -- m�jutatakse �ht juhuslikku filtrile vastavat olendeit
    | DrawCard                          -- toime olendi omanik v�tab kaardi
    deriving (Show, Read)

data CreatureEffect
    = Health Type Int                -- elupunktide muutmine
    | Attack Type Int                -- r�ndepunktide muutmine
    | Taunt Bool                     -- m�nituse muutmine
    deriving (Show, Read)
    
-- muutuse t��p
data Type
    = Relative                          -- negatiivne relatiivne muutmine on vigastamine 
    | Absolute                          -- absoluutne negatiivne muutmine ei ole vigastamine
    deriving (Show, Read)

-- filtri list on konjunktsioon, v�lja arvatud "Any" puhul    
data Filter
    = AnyCreature                       -- olendid
    | AnyHero                           -- kangelased
    | AnyFriendly                       -- "omad"    
    | Type MinionType                   -- kindlat t��pi olendid
    | Self                              -- m�jutav olend ise
    | Not [Filter]                      -- eitus
    | Any [Filter]                      -- disjunktsioon
    deriving (Show, Read)