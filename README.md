# FakeJack

Launch the game by running:

```
bin/fake_jack
```

This is a console based game based on below description.

The system will currently respond to the following commands:

```hit``` which will add one card to the players hand
```stand``` which will end the players turn and start the dealers turn

Any other command entered by the user will be ignored.

Commands are case sensitive.

Once each round is finished the application exits.

## Description

You are required to implement a variation of the Blackjack game.
The game is played between  a  dealer and  one  player. The  game is played with a  single deck of 52
cards. The card values are from 2 to 10, 11 (A), 12 (J), 13 (Q) and 14 (K).
At the start of the game the dealer shuffles the cards and deals an initial 2 card hand. These cards will
belong to both player and dealer hands. In case the sum of the 2 cards value is >= 20, the cards are
immediately re-dealt.

The player can chose to hit (request another card) or stand (stop if he is happy with the current hand).

The 2  initial  cards  plus any  other  cards  requested  by the  player will form the  player's hand.  If the
player hand goes > 21, dealer wins.

After the player calls stand,  the dealer hits (requests another card) until the sum of  the cards in his
hand is >= 17. The 2 initial cards plus any other cards hit by the dealer will form the dealer's hand. If
the dealer hand goes > 21, player wins.

If the sum of the card values in player's hand is <= 21 and the sum of the card values in the dealer's
hand is less than the player's sum then player wins, otherwise dealer wins.

If there is a tie, with player and dealer hands having same value, dealer wins.
