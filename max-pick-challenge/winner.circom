pragma circom 2.0.0;

// From circuit folder: circom guessing-game/winner.circom --r1cs

include "utils.circom";

template Winner(nInputs, N) {
    signal input guess[nInputs];
    signal input address[nInputs];
    signal input r[nInputs];
    signal input commitments[nInputs];
    signal output hash;
    signal output win_guess;
    signal output win_address;

    // Calculate the commitments
    component commit[nInputs];
    for (var i = 0; i < nInputs; i++) {
        commit[i] = Commit2();
        commit[i].input0 <== guess[i];
        commit[i].input1 <== address[i];
        commit[i].r <== r[i];
        commitments[i] === commit[i].c;
    }

    // Calculate hash chain
    component hash_chain = HashChain(nInputs);
    hash_chain.inputs <== commitments;
    hash <== hash_chain.hash;

    // Calculate the highest guess and its id
    component highest = UniqueHighestValWithId(nInputs, N);
    highest.inputs <== guess;
    highest.ids <== address;
    win_guess <== highest.outp;
    win_address <== highest.outp_id;
    log("win guess: ", win_guess);
}

component main = Winner(1000, 10);
