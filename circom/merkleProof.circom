pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template MerkleProofCircuit(n) {
    signal input leaf;
    signal input merkleRoot;
    signal input pathIndices[n];
    signal input siblings[n];
    signal output isValid;

    component hashChain[n];
    signal leftSelector0[n];
    signal rightSelector0[n];
    signal leftSelector1[n];
    signal rightSelector1[n];

    signal comparison;

    hashChain[0] = Poseidon(2);
    hashChain[0].inputs[0] <== leaf;
    hashChain[0].inputs[1] <== siblings[0];

    for (var i = 1; i < n; i++) {
        hashChain[i] = Poseidon(2);

        leftSelector0[i] <== pathIndices[i] * siblings[i];
        rightSelector0[i] <== (1 - pathIndices[i]) * hashChain[i - 1].out;

        hashChain[i].inputs[0] <== leftSelector0[i] + rightSelector0[i];

        leftSelector1[i] <== pathIndices[i] * hashChain[i - 1].out;
        rightSelector1[i] <== (1 - pathIndices[i]) * siblings[i];

        hashChain[i].inputs[1] <== leftSelector1[i] + rightSelector1[i];
    }

    comparison <== hashChain[n - 1].out - merkleRoot;
    isValid <== 1 - comparison * comparison;
}

component main = MerkleProofCircuit(4);
