/* global artifacts, contract, before, it, assert */
/* eslint-disable prefer-reflect */

const FinancieBancorConverter = artifacts.require('FinancieBancorConverter.sol');
const SmartToken = artifacts.require('SmartToken.sol');
const EtherToken = artifacts.require('EtherToken.sol');
const BancorFormula = artifacts.require('BancorFormula.sol');
const BancorGasPriceLimit = artifacts.require('BancorGasPriceLimit.sol');
const BancorQuickConverter = artifacts.require('BancorQuickConverter.sol');
const BancorConverterExtensions = artifacts.require('BancorConverterExtensions.sol');
const FinanciePlatformToken = artifacts.require('FinanciePlatformToken.sol');
const FinancieCardToken = artifacts.require('FinancieCardToken.sol');
const FinancieHeroesDutchAuction = artifacts.require('FinancieHeroesDutchAuction.sol');
const utils = require('./helpers/Utils');

const FinancieCore = artifacts.require('FinancieCore.sol');
const FinancieLog = artifacts.require('FinancieLog.sol');

const DutchAuction = artifacts.require('DutchAuction.sol');

const weight10Percent = 100000;
const gasPrice = 22000000000;
const gasPriceBad = 22000000001;

let token;
let tokenAddress;
let converterExtensionsAddress;
let platformToken;
let connectorToken;
let connectorToken2;
let platformTokenAddress;
let connectorTokenAddress;
let connectorTokenAddress2;
let converter;
let financieCore;
let quickConverter;
let log;

let etherToken;
let etherTokenAddress

var auction;
let bancor;
let cardToken;

// used by purchase/sale tests
async function initConverter(accounts, activate, maxConversionFee = 0) {
    platformToken = await FinanciePlatformToken.new('PF Token', 'ERC PF', 10000000000 * (10 ** 18));
    platformTokenAddress = platformToken.address;
    new Promise(() => console.log('[initConverter]PF Token:' + platformTokenAddress));

    etherToken = await EtherToken.new();
    etherTokenAddress = etherToken.address;
    new Promise(() => console.log('[initConverter]Ether Token:' + etherTokenAddress));
}

contract('BancorConverter', (accounts) => {
    before(async () => {
        let formula = await BancorFormula.new();
        let gasPriceLimit = await BancorGasPriceLimit.new(gasPrice);
        quickConverter = await BancorQuickConverter.new();
        let converterExtensions = await BancorConverterExtensions.new(formula.address, gasPriceLimit.address, quickConverter.address);
        converterExtensionsAddress = converterExtensions.address;
        new Promise(() => console.log('[BancorConverter]Converter Extension:' + converterExtensionsAddress));
    });

    it('verifies that getReturn returns a valid amount', async () => {
        converter = await initConverter(accounts, true);
        await quickConverter.registerEtherToken(etherTokenAddress, true);
    });

});

contract('FinancieCore', (accounts) => {
    before(async () => {
        financieCore = await FinancieCore.new(platformTokenAddress, etherTokenAddress);
        await financieCore.activateTargetContract(platformTokenAddress, true);
        await financieCore.activateTargetContract(etherTokenAddress, true);

        log = await FinancieLog.new();

        new Promise(() => console.log('[initFinancie]FinancieCore:' + financieCore.address));
        new Promise(() => console.log('[initFinancie]FinancieLog:' + log.address));
    });

    it('setup financie core', async () => {
        // 実験的販売
        await platformToken.transfer(financieCore.address, 100000000 * (10 ** 18));
        await log.transferOwnership(financieCore.address);
        await financieCore.setFinancieLog(log.address);
    });
});

/*
contract('Test Auction/Bancor', (accounts) => {
    before(async () => {
        cardToken = await FinancieCardToken.new('FinancieCardToken', 'FNCD', '0xA0d6B46ab1e40BEfc073E510e92AdB88C0A70c5C', financieCore.address);
        await financieCore.activateTargetContract(cardToken.address, true);
        auction = await FinancieHeroesDutchAuction.new(
          '0xA0d6B46ab1e40BEfc073E510e92AdB88C0A70c5C',
          '0x46a254FD6134eA0f564D07A305C0Db119a858d66',
          web3.eth.coinbase,
          1000000 / 10,
          0x1bc16d674ec80000 / 10000,
          0x5ddb1980,
          3);
        await cardToken.transfer(200000 * (10 ** 18));
        await auction.setup(financieCore.address, '0xA0d6B46ab1e40BEfc073E510e92AdB88C0A70c5C');
        await auction.start();
        await financieCore.activateTargetContract(auction.address, true);
    });

    it('setup auction', async () => {
        let stage = await auction.stage;
        assert.equal(2, stage);

        await auction.sendTransaction({from: web3.eth.coinbase, value:40 * (10 ** 18)});
    });
});
contract('Test FinancieLog', (accounts) => {
    it('setup financie log', async () => {

        let testLog = await FinancieLog.new();
        await testLog.recordLog(0x001, 0x011, 1, 0x111, 0x211, 300, 200);

        let log1 = await testLog.getSenderLogs(0x001);
        let log2 = await testLog.getSenderLogs(0x002);

        assert.equal(7, log1.length);
        assert.equal(1, log1[0].length);
        assert.equal(1, log1[1].length);
        assert.equal(1, log1[2].length);
        assert.equal(1, log1[3].length);
        assert.equal(1, log1[4].length);
        assert.equal(1, log1[5].length);
        assert.equal(1, log1[6].length);

        assert.equal(7, log2.length);
        assert.equal(0, log2[0].length);

        let log3 = await testLog.getTargetLogs(0x011);
        let log4 = await testLog.getTargetLogs(0x012);

        assert.equal(7, log3.length);
        assert.equal(1, log3[0].length);
        assert.equal(1, log3[1].length);
        assert.equal(1, log3[2].length);
        assert.equal(1, log3[3].length);
        assert.equal(1, log3[4].length);
        assert.equal(1, log3[5].length);
        assert.equal(1, log3[6].length);

        assert.equal(7, log4.length);
        assert.equal(0, log4[0].length);

        let log5 = await testLog.getFromLogs(0x111);
        let log6 = await testLog.getFromLogs(0x112);

        assert.equal(7, log5.length);
        assert.equal(1, log5[0].length);
        assert.equal(1, log5[1].length);
        assert.equal(1, log5[2].length);
        assert.equal(1, log5[3].length);
        assert.equal(1, log5[4].length);
        assert.equal(1, log5[5].length);
        assert.equal(1, log5[6].length);

        assert.equal(7, log6.length);
        assert.equal(0, log6[0].length);

        let log7 = await testLog.getToLogs(0x211);
        let log8 = await testLog.getToLogs(0x212);

        assert.equal(7, log7.length);
        assert.equal(1, log7[0].length);
        assert.equal(1, log7[1].length);
        assert.equal(1, log7[2].length);
        assert.equal(1, log7[3].length);
        assert.equal(1, log7[4].length);
        assert.equal(1, log7[5].length);
        assert.equal(1, log7[6].length);

        assert.equal(7, log8.length);
        assert.equal(0, log8[0].length);
    });
});
*/
