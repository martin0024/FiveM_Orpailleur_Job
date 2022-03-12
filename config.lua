
-- Main Config --
Config = {}
Config.Locale = 'en'


---------------------- Farm_items ------------------ 

Config.Farm1Random = {
    Max = 4,
    Min = 1
} 

Config.Farms = {
    Farm2 = {pepites= 4, poudre= 4},
    Farm3 = {poudre= 3, lingots = 3 },
    Seller = {minlingots = 100, onelingotprice = 30}
} 

-- Farm_Position
Config.position = {
    Farms = {
        FarmPoint1 = {x= 12 ,y=12 ,z=12},
        FarmPoint2 = {x= 12 ,y=12 ,z=12},
        FarmPoint3 = {x= 12 ,y=12 ,z=12},
    }
}



-- Farm_time (in ms, 1s = 1000 ms)
Config.timer = {
    FarmPoint1 = 15000,
    FarmPoint2 = 15000,
    FarmPoint3 = 15000
}

--------------------------------------------

-- Farm_Outfit
Config.Tenue = {
    Boss = {
        Shoes = 10,
        Legs = 25,
        Chest = 20,
        Arms = 15,
        Shirt= 41
    },
    CoPDG = {
        Shoes = 10,
        Legs = 25,
        Chest = 20,
        Arms = 15,
        Shirt= 41
    },
    Manager = {
        Shoes = 10,
        Legs = 25,
        Chest = 20,
        Arms = 15,
        Shirt= 41
    },
    Worker = {
        Shoes = 10,
        Legs = 25,
        Chest = 20,
        Arms = 15,
        Shirt= 41
    }

}


