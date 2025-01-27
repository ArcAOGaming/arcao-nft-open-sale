import { createDataItemSigner, spawn, message } from "@permaweb/aoconnect";
import { bundle } from 'luabundle';
import fs from 'fs';

// Constants
const MODULE = "ghSkge2sIUD_F00ym5sEimC63BDBuBrq4b5OcwxOjiw";
const SCHEDULER = "_GQ33BkPtZrqxA84vM8Zk-N2aO0toNNu_C-l-rawrBA";
const AUTHORITY = "fcoN_xJeisVsPXA-trzVAuIiqO3ydLQxM-L4XbrQKzY";

// Load wallet
const pathToWallet = 'wallet.json';

// Check if wallet exists
if (!fs.existsSync(pathToWallet)) {
    throw new Error('wallet.json not found in the root directory');
}

const walletData = fs.readFileSync(pathToWallet, 'utf-8');
const wallet = JSON.parse(walletData);

// Bundle Lua code
const bundledLua = bundle('./src/main.lua', {
    luaVersion: '5.3',
    force: true,
    paths: [
        'lib/share/lua/5.3/?.lua',
        '?.lua',
        './.?lua',
        './**?.lua',
        './**/**?.lua',
        './**/**/**?.lua',
        './**/**/**/**?.lua',
        './**/**/**/**/**?.lua',
        '?',
        './.?',
        './**?',
        './**/**?',
        './**/**/**?',
        './**/**/**/**?',
        './**/**/**/**/**?'
    ]
});

async function deploy() {
    try {
        // Spawn process
        const processId = await spawn({
            module: MODULE,
            scheduler: SCHEDULER,
            signer: createDataItemSigner(wallet),
            tags: [
                { name: "Authority", value: AUTHORITY },
            ]
        });

        console.log('Process ID:', processId);

        // Save process ID to file
        fs.writeFileSync('process_id.log', `Process ID: ${processId}\n`);

        // Send evaluation message
        const messageId = await message({
            process: processId,
            signer: createDataItemSigner(wallet),
            tags: [
                { name: "Action", value: "Eval" },
            ],
            data: bundledLua
        });

        console.log('Message ID:', messageId);

    } catch (error) {
        console.error('Deployment failed:', error);
        process.exit(1);
    }
}

deploy();
