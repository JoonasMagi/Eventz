-- Kasutajate tabel
CREATE TABLE user (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne kasutaja ID, unsigned int võimaldab positiivseid väärtusi kuni ~4 miljardit',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT 'Kasutajanimi, piiratud 50 tähemärgiga, unikaalne',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT 'E-posti aadress, standardne pikkus 100 tähemärki, unikaalne',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Krüpteeritud parool, 255 tähemärki on piisav enamikele räsialgoritmidele',
    first_name VARCHAR(50) NOT NULL COMMENT 'Eesnimi, piiratud 50 tähemärgiga',
    last_name VARCHAR(50) NOT NULL COMMENT 'Perekonnanimi, piiratud 50 tähemärgiga',
    phone VARCHAR(20) COMMENT 'Telefoninumber, kuni 20 tähemärki erinevate formaatide jaoks, pole kohustuslik',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Konto loomise aeg, DATETIME võimaldab täpset ajatempli salvestamist',
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimase muudatuse aeg, automaatselt uuendatakse',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Konto staatus, BOOLEAN on sobiv jah/ei väärtuste jaoks'
);

-- Asukohtade tabel
CREATE TABLE location (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne asukoha ID, unsigned int positiivsete väärtuste jaoks',
    name VARCHAR(100) NOT NULL COMMENT 'Asukoha nimi, piiratud 100 tähemärgiga',
    address VARCHAR(255) NOT NULL COMMENT 'Täielik aadress, standardne pikkus 255 tähemärki',
    city VARCHAR(50) NOT NULL COMMENT 'Linn, piiratud 50 tähemärgiga',
    country VARCHAR(50) NOT NULL COMMENT 'Riik, piiratud 50 tähemärgiga',
    postal_code VARCHAR(20) COMMENT 'Postiindeks, kuni 20 tähemärki erinevate formaatide jaoks, pole kohustuslik',
    latitude DECIMAL(10, 8) COMMENT 'Laiuskraad, DECIMAL võimaldab täpset koordinaadi salvestamist',
    longitude DECIMAL(11, 8) COMMENT 'Pikkuskraad, DECIMAL kuni 11 numbrit 8 komakohaga (pikkuskraad võib olla -180 kuni 180)',
    capacity INT UNSIGNED COMMENT 'Maksimaalne mahutavus, unsigned int võimaldab ainult positiivseid väärtusi, pole kohustuslik',
    description TEXT COMMENT 'Pikem kirjeldus asukohast, TEXT võimaldab salvestada suure koguse teksti',
    contact_info VARCHAR(255) COMMENT 'Kontaktandmed, standardne pikkus 255 tähemärki, pole kohustuslik',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Lisamise aeg, DATETIME võimaldab täpset ajatempli salvestamist',
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimase muudatuse aeg, automaatselt uuendatakse'
);

-- Ürituste tabel
CREATE TABLE event (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne ürituse ID, unsigned int positiivsete väärtuste jaoks',
    title VARCHAR(100) NOT NULL COMMENT 'Ürituse pealkiri, piiratud 100 tähemärgiga',
    description TEXT COMMENT 'Ürituse pikem kirjeldus, TEXT võimaldab salvestada suure koguse teksti',
    start_time DATETIME NOT NULL COMMENT 'Algusaeg, DATETIME võimaldab täpset ajatempli salvestamist',
    end_time DATETIME NOT NULL COMMENT 'Lõpuaeg, DATETIME võimaldab täpset ajatempli salvestamist',
    location_id INT UNSIGNED COMMENT 'Viide asukohale, INT UNSIGNED vastavuses location tabeli ID-ga, pole kohustuslik virtuaalüritustele',
    organizer_id INT UNSIGNED NOT NULL COMMENT 'Viide korraldajale, INT UNSIGNED vastavuses user tabeli ID-ga',
    max_participants INT UNSIGNED COMMENT 'Maksimaalne osalejate arv, unsigned int võimaldab ainult positiivseid väärtusi, pole kohustuslik',
    is_public BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Kas üritus on avalik, BOOLEAN on sobiv jah/ei väärtuste jaoks',
    status ENUM('draft', 'published', 'cancelled', 'completed') NOT NULL DEFAULT 'draft' COMMENT 'Ürituse olek, ENUM piirab väärtused kindlate valikutega',
    category VARCHAR(50) COMMENT 'Ürituse kategooria, piiratud 50 tähemärgiga, pole kohustuslik',
    image_url VARCHAR(255) COMMENT 'Ürituse pildi URL, standardne pikkus 255 tähemärki, pole kohustuslik',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Lisamise aeg, DATETIME võimaldab täpset ajatempli salvestamist',
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimase muudatuse aeg, automaatselt uuendatakse',
    FOREIGN KEY (location_id) REFERENCES location(id) ON DELETE SET NULL COMMENT 'Välisvõti asukohale, SET NULL võimaldab asukoha kustutamist ilma üritusi kustutamata',
    FOREIGN KEY (organizer_id) REFERENCES user(id) ON DELETE CASCADE COMMENT 'Välisvõti korraldajale, CASCADE kustutab automaatselt seotud üritused kui korraldaja kustutatakse'
);

-- Kasutajate ja ürituste seostabel (osalejad)
CREATE TABLE user_event (
    user_id INT UNSIGNED NOT NULL COMMENT 'Viide kasutajale, INT UNSIGNED vastavuses user tabeli ID-ga',
    event_id INT UNSIGNED NOT NULL COMMENT 'Viide üritusele, INT UNSIGNED vastavuses event tabeli ID-ga',
    registration_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registreerumise aeg, DATETIME võimaldab täpset ajatempli salvestamist',
    attendance_status ENUM('registered', 'confirmed', 'attended', 'cancelled') NOT NULL DEFAULT 'registered' COMMENT 'Osalemise staatus, ENUM piirab väärtused kindlate valikutega',
    notes TEXT COMMENT 'Märkused osalemise kohta, TEXT võimaldab salvestada suure koguse teksti',
    PRIMARY KEY (user_id, event_id) COMMENT 'Liitprimaarvõti, tagab et kasutaja saab registreeruda üritusele vaid ühe korra',
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE COMMENT 'Välisvõti kasutajale, CASCADE kustutab seose automaatselt kui kasutaja kustutatakse',
    FOREIGN KEY (event_id) REFERENCES event(id) ON DELETE CASCADE COMMENT 'Välisvõti üritusele, CASCADE kustutab seose automaatselt kui üritus kustutatakse'
);

-- Tagasiside tabel
CREATE TABLE feedback (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne tagasiside ID, unsigned int positiivsete väärtuste jaoks',
    event_id INT UNSIGNED NOT NULL COMMENT 'Viide üritusele, INT UNSIGNED vastavuses event tabeli ID-ga',
    user_id INT UNSIGNED NOT NULL COMMENT 'Viide kasutajale, INT UNSIGNED vastavuses user tabeli ID-ga',
    comment TEXT NOT NULL COMMENT 'Tagasiside sisu, TEXT võimaldab salvestada suure koguse teksti',
    submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Esitamise aeg, DATETIME võimaldab täpset ajatempli salvestamist',
    is_anonymous BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Kas tagasiside on anonüümne, BOOLEAN on sobiv jah/ei väärtuste jaoks',
    FOREIGN KEY (event_id) REFERENCES event(id) ON DELETE CASCADE COMMENT 'Välisvõti üritusele, CASCADE kustutab tagasiside automaatselt kui üritus kustutatakse',
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE COMMENT 'Välisvõti kasutajale, CASCADE kustutab tagasiside automaatselt kui kasutaja kustutatakse',
    UNIQUE KEY (event_id, user_id) COMMENT 'Unikaalne indeks, tagab et kasutaja saab anda üritusele vaid ühe tagasiside'
);

-- Hinnangute tabel
CREATE TABLE rating (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne hinnangu ID, unsigned int positiivsete väärtuste jaoks',
    event_id INT UNSIGNED NOT NULL COMMENT 'Viide üritusele, INT UNSIGNED vastavuses event tabeli ID-ga',
    user_id INT UNSIGNED NOT NULL COMMENT 'Viide kasutajale, INT UNSIGNED vastavuses user tabeli ID-ga',
    score TINYINT UNSIGNED NOT NULL COMMENT 'Hinne 1-5, TINYINT UNSIGNED on piisav väikeste täisarvude jaoks (0-255)',
    submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Esitamise aeg, DATETIME võimaldab täpset ajatempli salvestamist',
    FOREIGN KEY (event_id) REFERENCES event(id) ON DELETE CASCADE COMMENT 'Välisvõti üritusele, CASCADE kustutab hinnangu automaatselt kui üritus kustutatakse',
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE COMMENT 'Välisvõti kasutajale, CASCADE kustutab hinnangu automaatselt kui kasutaja kustutatakse',
    UNIQUE KEY (event_id, user_id) COMMENT 'Unikaalne indeks, tagab et kasutaja saab anda üritusele vaid ühe hinnangu',
    CHECK (score BETWEEN 1 AND 5) COMMENT 'Piirang, mis tagab et hinne jääb vahemikku 1-5'
);
