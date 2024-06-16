import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, network } from "hardhat";

import { Signers } from "../types";
import { deployLockFixture } from "./roulette.fixture";

describe("Roulette", function () {
  before(async function () {
    this.signers = {} as Signers;

    const signers = await ethers.getSigners();
    this.signers.admin = signers[0];

    this.loadFixture = loadFixture;
  });

  describe("test 1", function () {
    beforeEach(async function () {
      const { roulette, roulette_address, owner, address1, address2, address3 } =
        await this.loadFixture(deployLockFixture);

      this.roulette = roulette;
      this.roulette_address = roulette_address;
      this.owner = owner;
      this.address1 = address1;
      this.address2 = address2;
      this.address3 = address3;
    });

    it("buyTokens", async function () {
      const etherInWei = ethers.parseEther("1");
      await this.roulette.connect(this.address1).buyTokens({ value: etherInWei });
      await this.roulette.connect(this.address2).buyTokens({ value: etherInWei });
      await this.roulette.connect(this.address3).buyTokens({ value: etherInWei });

      await this.roulette
        .connect(this.address3)
        .balanceOf(this.address3)
        .then((balance: any) => {
          expect(balance).to.equals(1000);
        });
    });

    it('placeBet', async function () {
        const etherInWei = ethers.parseEther("1");

        await this.roulette.connect(this.address1).buyTokens({ value: etherInWei });
        await this.roulette.connect(this.address2).buyTokens({ value: etherInWei });
        await this.roulette.connect(this.address3).buyTokens({ value: etherInWei });
  
        await this.roulette.connect(this.address1).placeBetEven(1000);
        await this.roulette.connect(this.address2).placeBetOdd(1000);
        await this.roulette.connect(this.address3).placeBetOnNumber(1000, 13);

        await this.roulette.connect(this.address1).checkBetsOnEven().then((data: any) => {
            expect(data[0].length).equals(1);
        });

        await this.roulette.connect(this.address2).checkBetsOnOdd().then((data: any) => {
            expect(data[0].length).equals(1);

        });

        await this.roulette.connect(this.address3).checkBetsOnDigits().then((data: any) => {
            expect(data[0].length).equals(1);
        });
    });

    it("setSpinWheelResult", async function () {
        const etherInWei = ethers.parseEther("1");

        await this.roulette.connect(this.address1).buyTokens({ value: etherInWei });
        await this.roulette.connect(this.address2).buyTokens({ value: etherInWei });
        await this.roulette.connect(this.address3).buyTokens({ value: etherInWei });
  
        await this.roulette.connect(this.address1).placeBetEven(1000);
        await this.roulette.connect(this.address2).placeBetOdd(1000);
        await this.roulette.connect(this.address3).placeBetOnNumber(1000, 13);

        await this.roulette.connect(this.owner).setSpinWheelResult(13);

        await this.roulette.connect(this.owner).checkWinningNumber().then((data: any) => {
            expect(data).equals(13);
        });
    });

    it("transferWinnings", async function () {
        const etherInWei = ethers.parseEther("1");

        await this.roulette.connect(this.address1).buyTokens({ value: etherInWei });
        await this.roulette.connect(this.address2).buyTokens({ value: etherInWei });
        await this.roulette.connect(this.address3).buyTokens({ value: etherInWei });
  
        await this.roulette.connect(this.address1).placeBetEven(1000);
        await this.roulette.connect(this.address2).placeBetOdd(1000);
        await this.roulette.connect(this.address3).placeBetOnNumber(1000, 13);

        await this.roulette.connect(this.owner).setSpinWheelResult(13);

        await this.roulette.connect(this.owner).transferWinnings();

        await this.roulette.connect(this.address3).balanceOf(this.address3).then((data: any) => {
            expect(data).equals(19000);
        });

        await this.roulette.connect(this.address2).balanceOf(this.address2).then((data: any) => {
            expect(data).equals(1800);
        });

        await this.roulette.connect(this.address1).balanceOf(this.address1).then((data: any) => {
            expect(data).equals(0);
        });
    });

    it("sellTokens", async function () {
        const etherInWei = ethers.parseEther("1");

        await this.roulette.connect(this.address1).buyTokens({ value: etherInWei });
        await this.roulette.connect(this.address2).buyTokens({ value: etherInWei });
        await this.roulette.connect(this.address3).buyTokens({ value: etherInWei });
  
        await this.roulette.connect(this.address1).placeBetEven(1000);
        await this.roulette.connect(this.address2).placeBetOdd(1000);
        await this.roulette.connect(this.address3).placeBetOnNumber(1000, 13);

        await this.roulette.connect(this.owner).setSpinWheelResult(13);

        await this.roulette.connect(this.owner).transferWinnings();

        await this.roulette.connect(this.address3).sellTokens(19000);
        await this.roulette.connect(this.address2).sellTokens(1800);

        await this.roulette.connect(this.address3).balanceOf(this.address3).then((data: any) => {
            expect(data).equals(0);
        });

        await this.roulette.connect(this.address2).balanceOf(this.address2).then((data: any) => {
            expect(data).equals(0);
        });

        await this.roulette.connect(this.address1).balanceOf(this.address1).then((data: any) => {
            expect(data).equals(0);
        });
    });

    it("spinWheel", async function () {
        await this.roulette.connect(this.owner).spinWheel();

        await this.roulette.connect(this.address1).checkWinningNumber().then((data: number) => {
            expect(data).lessThanOrEqual(36);
        })
    })
  });
});
