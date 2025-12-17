const fs = require('fs');
const express = require("express");
const {google} = require('googleapis');
const gdoc = require("./gdoc");

//4/0AZEOvhVPZC8ONAa2wX3cZfOxYE2jUqauI1kO8nyJrwTJGzRkAWnS7ZSbLawT8JPlOg1E_w
// Load client secrets from a local file.
fs.readFile('credentials.json', (err, content) => {
    if (err) return console.log('Error loading client secret file:', err);
    // Authorize a client with credentials, then call the Google Sheets API.
    gdoc.authorize(JSON.parse(content), main);
});

function prepare_symbols_file(localization, excludeLanguages = []) {
    let result = "";
    let symbols = {};

    // Process localization data to add any additional unique characters used
    Object.keys(localization).forEach(lang => {
        if (!excludeLanguages.includes(lang)) {
            extractSymbols(localization[lang], symbols);
        }
    });

    // Compile all unique symbols into a single string result
    Object.keys(symbols).forEach(symbol => {
        result += symbol;
    });

    console.log("Compiled Symbols for " + (excludeLanguages.length ? "excluding " + excludeLanguages.join(", ") : "all languages") + ": " + result);
    return result;
}

function extractSymbols(data, symbols) {
    if (typeof data === 'string') {
        // Remove placeholders like %{count} before adding symbols
        data = data.replace(/%\{[^}]+\}/g, ''); // Correct regex to remove placeholders
        Array.from(data).forEach(char => {
            if (!symbols[char]) {
                symbols[char] = true;
            }
        });
    } else if (typeof data === 'object') {
        Object.values(data).forEach(value => {
            extractSymbols(value, symbols);
        });
    }
}

function generateFontForgeScript(inputText) {
    const maxParamsPerLine = 16;  // Define max number of parameters per SelectSingletons/SelectMoreSingletons call
    let unicodePoints = Array.from(inputText).map(char => {
        let hex = char.charCodeAt(0).toString(16).toUpperCase();
        return `"u${hex.padStart(4, '0')}"`;
    });

    // Prepare the initial part of the FontForge script with batches of selections
    let scriptParts = [];
    for (let i = 0; i < unicodePoints.length; i += maxParamsPerLine) {
        let batch = unicodePoints.slice(i, i + maxParamsPerLine);
        if (i === 0) {
            scriptParts.push(`SelectSingletons(${batch.join(", ")});`);
        } else {
            scriptParts.push(`SelectMoreSingletons(${batch.join(", ")});`);
        }
    }

    // Complete the script with the inversion and deletion commands
    scriptParts.push("SelectInvert();");
    scriptParts.push("DetachAndRemoveGlyphs();");
    scriptParts.push("Reencode(\"compacted\");");

    return scriptParts.join("\n");
}

function save_file(data,path){
    fs.writeFile(path, JSON.stringify(data), (err) => {
        if (err) {
            console.log(err);
            throw(err);
        } else {
            console.log("File saved:" + path);
        }
    });
}

function save_file_string(data,path){
    fs.writeFile(path, data, (err) => {
        if (err) {
            console.log(err);
            throw(err);
        } else {
            console.log("File saved:" + path);
        }
    });
}

async function download_localization(sheets, range, auth, spreadsheetId) {
    console.log("****** LOCALIZATION PARSE BEGIN ******");
    let rows = await gdoc.get(sheets, auth, spreadsheetId, range);
    let headers = rows[0];
    let result = {};

    // Initialize language keys dynamically from header row
    for (let j = 2; j < headers.length; j++) {
        let lang = headers[j];
        result[lang] = {};
    }

    // Parse all rows for localization entries
    let currentKey = "";
    rows.slice(1).forEach(row => {
        let key = row[0].trim();
        let plural = row[1].trim();
        if (key) currentKey = key;  // Update current key if it's not empty

        // Iterate over each language column based on header setup
        for (let j = 2; j < headers.length; j++) {
            let lang = headers[j];
            let text = row[j]
            if (!text) continue;  // Skip empty translations
             text = text.trim();  // Text for current cell
             text = text.replace(/<br\s*\/?>/gi, '\n');  // Replacing <br> or <br/> with a newline character

            if (!result[lang][currentKey]) result[lang][currentKey] = {};

            if (plural) {
                result[lang][currentKey][plural] = text;
            } else {
                result[lang][currentKey] = text;  // Direct assignment if no plural form
            }
        }
    });

    console.log("****** LOCALIZATION PARSE FINISHED ******");
    console.log(result);
    return result;
}

async function main(auth) {
    console.log("start");
    const sheets = google.sheets({version: 'v4', auth});
	//https://docs.google.com/spreadsheets/d/1BUmB7w0f4RVaqfJtRp3ix_3HKL0V5Izu-I9MB9NhCX4
    const config_sheet = "1BUmB7w0f4RVaqfJtRp3ix_3HKL0V5Izu-I9MB9NhCX4"

    let localization = await download_localization(sheets, "localization!A8:L1000", auth, config_sheet);
    let symbols_list_all = await prepare_symbols_file(localization)
	//exclude chinese japanese and korean symbols
    let symbols_list_small = await prepare_symbols_file(localization,['zh', 'ja', 'ko'])

    let font_forge_all = generateFontForgeScript(symbols_list_all);
    let font_forge_small = generateFontForgeScript(symbols_list_small);

    // List of locales
    const locales = Object.keys(localization);
    const output = { order: locales, localization: {} };

    // Get all unique keys from all locales
    const allKeys = new Set();
    locales.forEach(locale => {
        Object.keys(localization[locale]).forEach(key => {
            allKeys.add(key);
        });
    });

    // Populate the output object
    allKeys.forEach(key => {
        output.localization[key] = locales.map(locale => localization[locale][key] || null);
    });

    save_file(localization,"./localization/localization.json")
    save_file(output,"./localization/localization_compact.json")
    save_file(symbols_list_all,"./localization/symbol_list.txt")
    save_file(symbols_list_small,"./localization/symbol_list_small.txt")
	save_file_string(font_forge_all, "localization/font_forge_all.txt")
	save_file_string(font_forge_small, "localization/font_forge_small.txt")

    console.log("finish");

}

