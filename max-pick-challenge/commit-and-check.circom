pragma circom 2.0.0;

// From circuit folder: circom guessing-game/commit-and-check.circom --r1cs

include "utils.circom";

// Checks whether the 'guess' is in the range [MIN, MAX] and commits to it alongside the address of the user and a random number
template CommitAndCheck(MIN, MAX, N) {
    signal input guess; // The guess of the user
    signal input address; // The address of the user
    signal input r; // The randomness used in the commitment
    signal output c; // The commitment

    component check = CheckRange(MIN, MAX, N);
    check.inp <== guess;

    component commit = Commit2();
    commit.input0 <== guess;
    commit.input1 <== address;
    commit.r <== r;
    c <== commit.c;
}

component main {public [address]} = CommitAndCheck(1, 1000, 10);
