#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Blockchain::Ethereum::ABI::Decoder;

my $decoder = Blockchain::Ethereum::ABI::Decoder->new();

subtest "Int" => sub {
    my $data    = "0x0000000000000000000000000000000000000000000000000858898f93629000";
    my $decoded = $decoder->append('uint256')->decode($data)->[0];
    is $decoded->bstr + 0, 601381800000000000;
};

subtest "String" => sub {
    my $data =
        "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000063496620796f75206472696e6b206d7563682066726f6d206120626f74746c65206d61726b65642027706f69736f6e27206974206973206365727461696e20746f206469736167726565207769746820796f7520736f6f6e6572206f72206c617465722e0000000000000000000000000000000000000000000000000000000000";
    my $decoded = $decoder->append('string')->decode($data)->[0];
    is $decoded, "If you drink much from a bottle marked 'poison' it is certain to disagree with you sooner or later.";
};

subtest "Bytes" => sub {
    my $data =
        "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000063496620796f75206472696e6b206d7563682066726f6d206120626f74746c65206d61726b65642027706f69736f6e27206974206973206365727461696e20746f206469736167726565207769746820796f7520736f6f6e6572206f72206c617465722e0000000000000000000000000000000000000000000000000000000000";

    my $decoded = $decoder->append('bytes')->decode($data)->[0];
    is $decoded,
        "0x496620796f75206472696e6b206d7563682066726f6d206120626f74746c65206d61726b65642027706f69736f6e27206974206973206365727461696e20746f206469736167726565207769746820796f7520736f6f6e6572206f72206c617465722e";
};

subtest "Address" => sub {
    my $data = "0x000000000000000000000000541662633a0097e3b429685505cd4d233dfe9167";

    my $decoded = $decoder->append('address')->decode($data)->[0];
    is $decoded, "0x541662633a0097e3b429685505cd4d233dfe9167";
};

subtest "Static Arrays" => sub {
    my $data = "0x61626300000000000000000000000000000000000000000000000000000000006465660000000000000000000000000000000000000000000000000000000000";
    my $decoded = $decoder->append('bytes3[2]')->decode($data);
    is_deeply $decoded->@*, ['0x' . unpack("H*", 'abc'), '0x' . unpack("H*", 'def')];
};

subtest "Dynamic Arrays" => sub {
    my $data =
        "0000000000000000000000000000000000000000000000000000000063538907000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000000e404e45aaf000000000000000000000000def1ca1fb7fbcdc777520aa7f396b4e015f497ab000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000000000000000000000000000000000000000271000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000023b7ca5c85abab30000000000000000000000000000000000000000000000000000088face1a63358000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004449404b7c00000000000000000000000000000000000000000000000000088face1a633580000000000000000000000009b4ac5feb3fa9c087906cce730dc1bed34f0851400000000000000000000000000000000000000000000000000000000";
    my $decoded = $decoder->append('uint256')->append('bytes[]')->decode($data);
    is_deeply $decoded,
        [
        1666418951,
        [
            '0x04e45aaf000000000000000000000000def1ca1fb7fbcdc777520aa7f396b4e015f497ab000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000000000000000000000000000000000000000271000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000023b7ca5c85abab30000000000000000000000000000000000000000000000000000088face1a633580000000000000000000000000000000000000000000000000000000000000000',
            '0x49404b7c00000000000000000000000000000000000000000000000000088face1a633580000000000000000000000009b4ac5feb3fa9c087906cce730dc1bed34f08514'
        ]];
};

subtest "Tuples" => sub {
    my $data =
        '000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a200f559c20000000000000000000000000005e9988b0c47b47a5b1d7d2e65358789044c2ef9a000000000000000000000000004c00500000ad104d7dbd00e3ae0a5c00560c000000000000000000000000002cc8342d7c8bff5a213eb2cde39de9a59b3461a7000000000000000000000000000000000000000000000000000000000000b39d0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000633bf4a9000000000000000000000000000000000000000000000000000000006364b4590000000000000000000000000000000000000000000000000000000000000000360c6ebe0000000000000000000000000000000000000000a3d2067fd6a0483c0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f00000000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f00000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000044364c5bb0000000000000000000000000000000a26b00c1f0df003000390027140000faa71900000000000000000000000000000000000000000000000000001b48eb57e0000000000000000000000000002dc05e282a6829c66e91b655f91129800fb9dbdf000000000000000000000000000000000000000000000000000028ed6103d0000000000000000000000000002a1de3f4582bb617225e32922ba789693156fc8c0000000000000000000000000000000000000000000000000000000000000041d410c95bb9d3f04cb0c2340a5fa890e506c2d9159aadd8bf06bcd03e56a9f48c44115a13a2f9fc6184cfe40747ebff2da100329aa385fa19de112ed2f3ed11731b00000000000000000000000000000000000000000000000000000000000000';

    my $decoded = $decoder->append(
        '(address,uint256,uint256,address,address,address,uint256,uint256,uint8,uint256,uint256,bytes32,uint256,bytes32,bytes32,uint256,(uint256,address)[],bytes)'
    )->decode($data)->[0];

    is_deeply $decoded,
        [
        '0x0000000000000000000000000000000000000000',
        Math::BigInt->new(0),
        Math::BigInt->new(2850000000000000),
        '0x5e9988b0c47b47a5b1d7d2e65358789044c2ef9a',
        '0x004c00500000ad104d7dbd00e3ae0a5c00560c00',
        '0x2cc8342d7c8bff5a213eb2cde39de9a59b3461a7',
        Math::BigInt->new(45981),
        Math::BigInt->new(1),
        Math::BigInt->new(2),
        Math::BigInt->new(1664873641),
        Math::BigInt->new(1667544153),
        '0x0000000000000000000000000000000000000000000000000000000000000000',
        Math::BigInt->new('24446860302761739304752683030156737591518664810215442929812187193154675427388'),
        '0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000',
        '0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000',
        Math::BigInt->new(3),
        [
            [Math::BigInt->new(75000000000000), '0x0000a26b00c1f0df003000390027140000faa719'],
            [Math::BigInt->new(30000000000000), '0x2dc05e282a6829c66e91b655f91129800fb9dbdf'],
            [Math::BigInt->new(45000000000000), '0x2a1de3f4582bb617225e32922ba789693156fc8c']
        ],
        '0xd410c95bb9d3f04cb0c2340a5fa890e506c2d9159aadd8bf06bcd03e56a9f48c44115a13a2f9fc6184cfe40747ebff2da100329aa385fa19de112ed2f3ed11731b'
        ];

};

done_testing;

