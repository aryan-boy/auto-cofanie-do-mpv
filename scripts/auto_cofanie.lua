function przelacz_skrypt()
    if skrypt_wlaczony == true then
        skrypt_wlaczony = false
        mp.osd_message("auto-cofanie wylaczone")
    elseif skrypt_wlaczony == false then
        skrypt_wlaczony = true
        mp.osd_message("auto-cofanie wlaczone")
    end
end

function raportuj_przewijanie()
    if ignoruj_seek ~= true then
        przewijanie = true
    else
        ignoruj_seek = false
    end
end

function cofnij(wartosc)
    -- przewijanie czynione przez te funkcje powinno to byc zignorowane
    ignoruj_seek = true
    mp.commandv("seek", tostring(-wartosc), "relative", "exact")
    --print("cofanie o", math.floor(wartosc*100)/100, "s")
end

function funkcja_czasomierza()
    -- koniec dzialania po uplywie 5 minut albo gdy uzytkownik zacznie przewijac
    if sekundy >= 300 or skrypt_wlaczony == false or przewijanie == true then
        czasomierz:kill()
    elseif sekundy > 15 then
        cofnij(ile_cofnac)
        -- wraz z uplywem czasu krok auto-cofania bedzie sie zmniejszac
        ile_cofnac = ile_cofnac * 0.95
    end
    sekundy = sekundy + 5
end

function okresowe_cofanie(nazwa, wartosc)
    if wartosc == true and skrypt_wlaczony == true then
        przewijanie = false
        sekundy = 0
        ile_cofnac = 1
        czasomierz = mp.add_periodic_timer(5, funkcja_czasomierza)
    elseif czasomierz ~= nil then
        czasomierz:kill()
    end
end

skrypt_wlaczony = true
mp.observe_property("pause", "bool", okresowe_cofanie)
mp.register_event("seek", raportuj_przewijanie)
mp.register_script_message("auto_cofanie", przelacz_skrypt)
