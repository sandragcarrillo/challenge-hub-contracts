import { expect } from "chai";
import hardhat from "hardhat";
const { ethers } = hardhat;

describe("CuriosChallenge", function () {
    let verifier, curiosChallenge, owner, participant;

    before(async function () {
        [owner, participant] = await ethers.getSigners();

        const Verifier = await ethers.getContractFactory("Groth16Verifier");
        verifier = await Verifier.deploy();
        await verifier.deployed();

        const CuriosChallenge = await ethers.getContractFactory("CuriosChallenge");
        curiosChallenge = await CuriosChallenge.deploy(verifier.address, owner.address);
        await curiosChallenge.deployed();
    });

    it("should allow creation of a challenge", async function () {
        const tx = await curiosChallenge
            .connect(owner)
            .createChallenge(
                "Test Challenge",
                "Solve the puzzle",
                3,
                "0x123456789abcdef123456789abcdef123456789abcdef123456789abcdef1234", // Dummy Merkle Root
                "Some metadata",
                { value: ethers.utils.parseEther("1.0") }
            );
        await tx.wait();

        const challenge = await curiosChallenge.getChallenge(owner.address, 0);
        expect(challenge.name).to.equal("Test Challenge");
        expect(challenge.prizePool.toString()).to.equal(ethers.utils.parseEther("1.0").toString());
    });

    it("should verify a ZK proof and allow claiming prize", async function () {
        // Mocked proof
        const a = [1, 2];
        const b = [[3, 4], [5, 6]];
        const c = [7, 8];
        const publicSignals = [
            ethers.BigNumber.from("0x123456789abcdef123456789abcdef123456789abcdef123456789abcdef1234")
        ];

        const claimTx = await curiosChallenge
            .connect(participant)
            .claimPrize(owner.address, 0, a, b, c, publicSignals);
        await claimTx.wait();

        const challenge = await curiosChallenge.getChallenge(owner.address, 0);
        expect(challenge.prizePool.toString()).to.be.below(ethers.utils.parseEther("1.0").toString());
    });
});
