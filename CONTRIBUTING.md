# Contributing

This project welcomes contributions for bug fixes, documentation updates, new
features, or whatever you might like. Development is done through GitHub pull
requests. Feel free to reach out on the [Bytecode Alliance
Zulip](https://bytecodealliance.zulipchat.com/) as well if you'd like assistance
in contributing or would just like to say hi.

### Building From Source

To create a debug build of this project from source, execute this command at the
root of the repository:

```
$ cargo build
```

And the resulting binary is located at `./target/debug/wasm-tools` for the
current platform.

An optimized build can be produced with:

```
$ cargo build --release
```

### Testing

Many crates in this repository (located in `crates/*`) both have unit tests
(`#[test]` functions throughout the source) and integration tests
(`crates/*/tests/*.rs`). Testing an individual crate can be done with:

```
$ cargo test -p wasmparser
```

Running all tests can be done by first ensuring that the spec test suite is
checked out:

```
$ git submodule update --init
```

and then using Cargo to execute all tests:

```
$ cargo test --workspace
```

The majority of all tests is located in `tests/cli/*` and can be run with:

```
$ cargo test --test cli
```

Each individual file is a standalone test and documents at the top how to run
it. Running individual tests can be done through:

```
$ cargo test --test cli -- test_name_filter
```

Or you can use `cargo run` plus the test's arguments to run a single test.

```
$ cargo run wast tests/cli/empty.wast
```

Running just the spec test suite can be done with:

```
$ cargo test --test cli -- spec
```

and running a single spec test can be done with an argument to this command as a
string filter on the filename.

```
$ cargo test --test cli binary-leb128.wast
$ cargo run wast tests/testsuite/binary-leb128.wast --ignore-error-messages
```

The `tests/cli` tests suite is documented as a self-describing test at
`tests/cli/readme.wat`. Each test describes what subcommand of `wasm-tools` is
run and the test is itself the input.

The `tests/testsuite` folder is a git submodule pointing to the [upstream test
suite repository](https://github.com/WebAssembly/testsuite/) and is where spec
tests come from. The `tests/snapshots` folder contains golden output files
which correspond to the `wasmprinter`-printed version of binaries of all tests.
These files are used to view the impact of changes to `wasmprinter`.

Many tests throughout the repository have automatically generated files
associated with them which reflect the expected output of an operation. This is
done to view, during code review, the impact of changes made. It's not expected
that these files need to be edited by hand, but instead setting the environment
variable `BLESS=1` when running tests will update all of these test
expectations.

### Continuous Integration

All changes to `wasm-tools` are required to pass the CI suite powered by GitHub
Actions. Pull requests will automatically have checks performed and can only be
merged once all tests are passing. CI checks currently include:

* Code is all formatted correctly (use `cargo fmt` locally to pass this)
* Tests pass on Rust stable, beta, and Nightly.
* Tests pass on Linux, macOS, and Windows.
* This tool can be compiled to WebAssembly using the `wasm32-wasip1` target.
* Fuzzers can be built.
* Various miscellaneous checks such as building the tool with various
  combinations of Cargo features.

### Fuzzing

This repository uses LLVM's libFuzzer through the [`cargo
fuzz`](https://github.com/rust-fuzz/cargo-fuzz) tool. Building fuzzers requires
a Nightly Rust toolchain which can be acquired with Rustup-based installations
of Rust by executing:

```
$ rustup update nightly
```

Next the `cargo-fuzz` runner should be installed:

```
$ cargo install cargo-fuzz
```

Fuzzers are then built with:

```
$ cargo +nightly fuzz build
```

Useful options to this can include:

* `--dev` - build fuzzers in debug mode instead of release mode (default is
  release)
* `--sanitizer none` - Rust doesn't benefit much from AddressSanitizer for
  example so disabling sanitizers can improve fuzzing performance and build more
  quickly too.

The fuzzing binary for this project is located at
`target/$host_target/release/run`. Due to limitations on OSS-Fuzz all fuzzers
are combined into a single binary at this time. This binary can be run with:

```
$ cargo +nightly fuzz run run
```

The main driver for fuzzing is located at `fuzz/fuzz_targets/run.rs`. This
driver dispatches, based on the input, to a number of other fuzzers. Each
individual fuzzer lives in `fuzz/src/*.rs`.

Running a single fuzzer can be done by configuring the `FUZZER` environment
variable:

```
$ FUZZER=roundtrip cargo +nightly fuzz run run
```

More documentation of `cargo fuzz` can [be found
online](https://rust-fuzz.github.io/book/cargo-fuzz.html).

# License

This project is licensed under the Apache 2.0 license with the LLVM exception.
See [LICENSE](LICENSE) for more details.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in this project by you, as defined in the Apache-2.0 license,
shall be licensed as above, without any additional terms or conditions.
