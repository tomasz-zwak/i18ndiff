const fs = require('fs');

function flattenObject(obj, parentKey = '') {
  let result = {};

  for (const key in obj) {
    if (obj.hasOwnProperty(key)) {
      const newKey = parentKey ? `${parentKey}.${key}` : key;

      if (typeof obj[key] === 'object' && !Array.isArray(obj[key])) {
        const nestedObj = flattenObject(obj[key], newKey);
        result = { ...result, ...nestedObj };
      } else {
        result[newKey] = obj[key];
      }
    }
  }

  return result;
}

// Read JSON file
if (process.argv.length < 3) {
  console.error('Usage: node flatten.js <old.json> <new.json>');
  process.exit(1);
}

const oldJsonFileKeysPath = process.argv[2];
const newJsonFileKeysPath = process.argv[3];
const oldJsonKeys = JSON.parse(fs.readFileSync(oldJsonFileKeysPath, 'utf8'));
const newJsonKeys = JSON.parse(fs.readFileSync(newJsonFileKeysPath, 'utf8'));

// Flatten the JSON object
const flattenedOldJsonKeys = flattenObject(oldJsonKeys);
const flattenedNewJsonKeys = flattenObject(newJsonKeys);

const existingTranslationKeys = Object.keys(flattenedOldJsonKeys)
const extendedtranslationkeys = Object.keys(flattenedNewJsonKeys)

const newTranslationKeys = extendedtranslationkeys.filter(key => !existingTranslationKeys.includes(key))

const diff = newTranslationKeys.sort()

console.log(diff)

fs.writeFileSync('i18ndiff.json', JSON.stringify(diff, null, 1))

