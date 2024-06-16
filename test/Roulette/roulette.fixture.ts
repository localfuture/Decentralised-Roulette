import { ethers } from "hardhat";

import type { Roulette } from "../../types/contracts/Roulette";
import type { Roulette__factory } from "../../types/factories/contracts/Roulette__factory";

export async function deployLockFixture() {
  const [owner, address1, address2, address3] = await ethers.getSigners();

  const Roulette = (await ethers.getContractFactory("Roulette")) as Roulette__factory;
  const roulette = (await Roulette.deploy()) as Roulette;
  const roulette_address = await roulette.getAddress();


  return {
    roulette,
    roulette_address,
    owner,
    address1,
    address2,
    address3
  };
}