-- Made by ϻartin#4322 --


-- Main Config --
Config = {}
Config.Locale = 'en'

---------------------- Farm_items ------------------ 

Config.Farm1Random = {
    Max = 4,
    Min = 1
} 


Config.Farms = {
    Farm2 = {pepites = 2, poudre= 4},
    Farm3 = {poudre= 3, lingots = 3 },
    Seller = {minlingots = 100, onelingotprice = 30}
}

-- Farm_Position

--Config.position = {
--    Farms = {
--        FarmPoint1 = {x= 12 ,y=12 ,z=12},
--        FarmPoint2 = {x= 12 ,y=12 ,z=12},
--        FarmPoint3 = {x= 12 ,y=12 ,z=12},
--    }
--}

-- Farm_time (in ms, 1s = 1000 ms)
Config.timer = {
    FarmRecolte = 15000,
    FarmTraitement1 = 15000,
    FarmTraitement2 = 15000
}

--------------------------------------------

-- Farm_Outfit
Config.Tenue = {
    Boss = {
        Shoes = 10,
        Legs = 25,
        Chest = 20,
        Arms = 4,
        Shirt= 4
    },
    CoPDG = {
        Shoes = 10,
        Legs = 25,
        Chest = 10,
        Arms = 1,
        Shirt= 3
    },
    Manager = {
        Shoes = 7,
        Legs = 35,
        Chest = 242,
        Arms = 0,
        Shirt= 15
    },
    Worker = {
        Shoes = 25,
        Legs = 9,
        Chest = 97,
        Arms = 0,
        Shirt= 15,
        Bag= 41
    }

}


