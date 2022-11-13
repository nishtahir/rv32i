/**
 * Pad a file with 0's to a given length
 * Usage:
 *     node scripts/zext.js [file] [len = 2048]
 */

const fs = require('fs');
const [file, inputSize = '2048'] = process.argv.slice(2);
size = parseInt(inputSize);

const content = fs.readFileSync(file)
    .toString('ascii')
    .trim()
    .split('\n');

const zext = content
    .concat(Array(size).fill('00000000'))
    .slice(0, parseInt(size))
    .join('\n');

fs.writeFileSync(file, zext)