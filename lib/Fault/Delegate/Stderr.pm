#================================ Stderr.pm ===================================
# Filename:             Stderr.pm
# Description:          Stderr print logger delegate.
# Original Author:      Dale M. Amon
# Revised by:           $Author: amon $ 
# Date:                 $Date: 2008-07-22 14:32:17 $ 
# Version:              $Revision: 1.1 $
# License:		LGPL 2.1, Perl Artistic or BSD
#
#=============================================================================
use strict;
use Fault::Delegate;
use Fault::Msg;

package Fault::Delegate::Stderr;
use vars qw{@ISA};
@ISA = qw( Fault::Delegate );

#=============================================================================
#                      Family internal methods
#=============================================================================
# Warn is used here because if you can't even print to stderr you are probably
# effed so you might as well punt directly to Perl and see if it can do any 
# better!

sub _write ($$) {
    my ($self,$msg) = @_;    
    my $line        = $msg->stamped_log_line;

    if (!print STDERR "$line\n") {
	warn ("$0: Failed to log message to stderr: \'$line\'!\n");
	return 0;
    }
    return 1;
}

#=============================================================================
#		      Primary Logger Callback Methods
#=============================================================================
# Utilizes Fault::Delegate parent methods with subclass overrides seen above.

#=============================================================================
#                       Pod Documentation
#=============================================================================
# You may extract and format the documentation section with the 'perldoc' cmd.

=head1 NAME

Fault::Delegate::Stderr - Stderr print logger delegate

=head1 SYNOPSIS

 use Fault::Delegate::Stderr;
 $self = Fault::Delegate::Stderr->new;
 $okay = $self->log ($msg);

=head1 Inheritance

 UNIVERSAL
   Fault::Delegate
     Fault::Delegate::Stderr

=head1 Description

This is a Logger delegate that writes all the log messages to stderr. It is
Logger's default delegate if no other is given. It is also a pretty good
one to start with when you are trying to understand how this system works.

It satisfies the absolute minimum requirements of the Fault::Delegate logger 
delegate protocol.

=head1 Examples

 use Fault::Delegate::Stderr;
 use Fault::Logger;
 use Fault::Msg;

 my $msg       = Fault::Msg                   ("Arf!");
 my $baz       = Fault::Delegate::Stderr->new ("/tmp/mylogfile");
 my $waslogged = $baz->log                    ($msg);

                 Fault::Logger->new           ($baz);
 my $waslogged = Fault::Logger->log           ("Bow! Wow!");

=head1 Instance Variables

None.

=head1 Class Methods

=over 4

=item B<$delegate = Fault::Delegate::Stderr-E<gt>new>

Create a logger delegate object that prints log messages to stderr. Prints
a warning message and returns undef on failure.

=back 4

=head1 Logger Protocol Instance Methods

=over 4

=item B<$okay = $self-E<gt>log ($msg)>

Print a time-stamped message to stderr using information
taken from Fault::Msg object $msg in the format:

      $date $time UTC> $process: $type($priority): $msg\n

for example:

      20021207 223010 UTC> MyProcess: NOTE(notice): Nothing happened today.\n

Return true if the message was printed.

=back 4

=head1 Private Class Methods

None.

=head1 Private Instance Methods

=over 4

=item B<$bool = $self-E<gt>_write ($msg)>

Impliments the above override to the internal family protocol utilized by 
the Fault:Delegate log and test methods.

=back 4

=head1 Errors and Warnings

Local warning messages are issued if the sys logger cannot be reached or has 
any problems whatever. 

=head1 SEE ALSO

Fault::Logger, Fault::Delegate, Fault::Msg

=head1 AUTHOR

Dale Amon <amon@vnl.com>

=cut

#=============================================================================
#                                CVS HISTORY
#=============================================================================
# $Log: Stderr.pm,v $
# Revision 1.1  2008-07-22 14:32:17  amon
# Added Notepad and Delegate::Stderr classes
#
# 20080722      Dale Amon <amon@vnl.com>
#               Modified old Fault::Delegate::Stdout code
#		to print to stderr instead of stdout.
1;
