package Blockchain::Ethereum::ABI::Type::Int;

use v5.26;
use strict;
use warnings;

use Carp;
use Math::BigInt;
use parent qw(Blockchain::Ethereum::ABI::Type);

use constant DEFAULT_INT_SIZE => 256;

sub encode {
    my $self = shift;
    return $self->_encoded if $self->_encoded;

    my $bdata = Math::BigInt->new($self->_data);

    croak "Invalid numeric data @{[$self->_data]}" if $bdata->is_nan;

    croak "Invalid data length, signature: @{[$self->fixed_length]}, data length: @{[$bdata->length]}"
        if $self->fixed_length && $bdata->length > $self->fixed_length;

    croak "Invalid negative numeric data @{[$self->_data]}"
        if $bdata->is_neg && $self->_signature =~ /^uint|bool/;

    croak "Invalid bool data it must be 1 or 0 but given @{[$self->_data]}"
        if !$bdata->is_zero && !$bdata->is_one && $self->_signature =~ /^bool/;

    $self->_push_static($self->pad_left($bdata->to_hex));

    return $self->_encoded;
}

sub decode {
    my $self = shift;
    return Math::BigInt->from_hex($self->_data->[0]);
}

sub fixed_length {
    my $self = shift;
    if ($self->_signature =~ /[a-z](\d+)/) {
        return $1;
    }
    return DEFAULT_INT_SIZE;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Blockchain::Ethereum::ABI::Int - Interface for solidity uint/int/bool type

=head1 SYNOPSIS

Allows you to define and instantiate a solidity address type:

    my $type = Blockchain::Ethereum::ABI::Int->new(
        signature => $signature,
        data      => $value
    );

    $type->encode();
    ...

In most cases you don't want to use this directly, use instead:

=over 4

=item * B<Encoder>: L<Blockchain::Ethereum::ABI::Encoder>

=item * B<Decoder>: L<Blockchain::Ethereum::ABI::Decoder>

=back

=head1 METHODS

=head2 encode

Encodes the given data to the type of the signature

Usage:

    encode() -> encoded string

=over 4

=back

=head2 decode

Decodes the given data to the type of the signature

Usage:

    decoded() -> L<Math::BigInt>

=over 4

=back

L<Math::BigInt>

=head1 AUTHOR

Reginaldo Costa, C<< <refeco at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to L<https://github.com/refeco/perl-ABI>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Blockchain::Ethereum::ABI::Int

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by REFECO.

This is free software, licensed under:

  The MIT License

=cut