��# 
 
 #   b y   n o d e r e d 2 m r u b y   c o d e   g e n e r a t o r 
 
 # 
 
 i n j e c t s   =   [ { : i d = > : n _ 9 3 4 0 1 7 e 3 5 2 4 b 2 b d d , 
 
     : d e l a y = > 0 . 1 , 
 
     : r e p e a t = > 1 . 0 , 
 
     : p a y l o a d = > " " , 
 
     : w i r e s = > [ : n _ 4 a e 1 2 f 0 c 5 c 5 2 0 6 5 5 ] } ] 
 
 n o d e s   =   [ { : i d = > : n _ 4 a e 1 2 f 0 c 5 c 5 2 0 6 5 5 , 
 
     : t y p e = > : g p i o , 
 
     : t a r g e t P o r t = > 0 , 
 
     : w i r e s = > [ ] } ] 
 
 
 
 #   g l o b a l   v a r i a b l e 
 
 $ g p i o N u m   =   { }               # n u m b e r   o f   p i n 
 
 $ g p i o V a l u e   =   0             # v a l u e   f o r   g p i o 
 
 $ p a y L o a d   =   0                 # v a l u e   o f   p a y l o a d   i n   i n j e c t - n o d e 
 
 
 
 # 
 
 #   c a l s s   G P I O 
 
 # 
 
 # = b e g i n 
 
 c l a s s   G P I O 
 
     a t t r _ a c c e s s o r   : p i n N u m 
 
 
 
     d e f   i n i t i a l i z e ( p i n N u m ) 
 
         @ p i n N u m   =   p i n N u m 
 
     e n d 
 
 
 
     d e f   w r i t e ( v a l u e ) 
 
         p u t s   " W r i t i n g   # { v a l u e }   t o   G P I O   # { @ p i n N u m } ,   O u t   b y   # { $ g p i o V a l u e } " 
 
         p u t s   " $ p a y L o a d   =   # { $ p a y L o a d } ,   $ g p i o V a l u e   =   # { $ g p i o V a l u e } " 
 
     e n d 
 
 e n d 
 
 # = e n d 
 
 
 
 # 
 
 #   n o d e   d e p e n d e n t   i m p l e m e n t a t i o n 
 
 # 
 
 
 
 # g p i o - n o d e 
 
 d e f   p r o c e s s _ n o d e _ g p i o ( n o d e ,   m s g ) 
 
     p u t s   " n o d e = # { n o d e } " 
 
     t a r g e t P o r t   =   n o d e [ : t a r g e t P o r t ] 
 
     $ p a y L o a d   =   m s g [ : p a y l o a d ] 
 
 
 
 #   G P I O   # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 
 = b e g i n 
 
     i f   $ g p i o N u m [ t a r g e t P o r t ] . n i l ?                                         #   c r e a t i n g   i n s t a n c e   f o r   p i n 
 
         g p i o   =   G P I O . n e w ( t a r g e t P o r t ) 
 
         $ g p i o N u m [ t a r g e t P o r t ]   =   g p i o 
 
         p u t s   " S e t t i n g   u p   p i n M o d e   f o r   p i n   # { t a r g e t P o r t } " 
 
     e l s e 
 
         g p i o   =   $ g p i o N u m [ t a r g e t P o r t ] 
 
         p u t s   " R e u s i n g   p i n M o d e   f o r   p i n   # { t a r g e t P o r t } " 
 
     e n d 
 
 
 
     i f   $ p a y L o a d . n i l ?                                                                 #   p a y l o a d = n i l 
 
         i f   $ g p i o V a l u e   = =   0 
 
             # d i g i t a l W r i t e ( $ g p i o N u m [ t a r g e t P o r t ] ,   1 ) 
 
             g p i o . w r i t e   1 
 
             $ g p i o V a l u e   =   1 
 
         e l s i f   $ g p i o V a l u e   = =   1 
 
             # d i g i t a l W r i t e ( $ g p i o N u m [ t a r g e t P o r t ] ,   0 ) 
 
             g p i o . w r i t e   0 
 
             $ g p i o V a l u e   =   0 
 
         e n d 
 
     e l s e                                                                                         #   p a y l o a d ! = n i l 
 
         i f   $ g p i o V a l u e   = =   0 
 
             # d i g i t a l W r i t e ( $ g p i o N u m [ t a r g e t P o r t ] ,   1 ) 
 
             g p i o . w r i t e   $ p a y L o a d 
 
             $ g p i o V a l u e   =   $ p a y L o a d 
 
         e l s e 
 
             # d i g i t a l W r i t e ( $ g p i o N u m [ t a r g e t P o r t ] ,   0 ) 
 
             g p i o . w r i t e   0 
 
             $ g p i o V a l u e   =   0 
 
         e n d 
 
     e n d 
 
 e n d 
 
 = e n d 
 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 
 
 
 #   t e s t   G P I O   # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 
 # = b e g i n 
 
     i f   $ g p i o N u m [ t a r g e t P o r t ] . n i l ?           # p i n ju�Sn0�0�0�0�0�0�0\Ob
 
         g p i o   =   G P I O . n e w ( t a r g e t P o r t ) 
 
         $ g p i o N u m [ t a r g e t P o r t ]   =   g p i o 
 
         p u t s   " S e t t i n g   u p   p i n M o d e   f o r   p i n   # { t a r g e t P o r t } " 
 
         p u t s   " $ p a y L o a d   =   # { $ p a y L o a d } ,   $ g p i o V a l u e   =   # { $ g p i o V a l u e } " 
 
     e l s e 
 
         g p i o   =   $ g p i o N u m [ t a r g e t P o r t ] 
 
         p u t s   " R e u s i n g   p i n M o d e   f o r   p i n   # { t a r g e t P o r t } " 
 
         p u t s   " # { $ i n j e c t [ : c n t ] } " 
 
         # p u t s   " $ p a y L o a d   =   # { $ p a y L o a d } ,   $ g p i o V a l u e   =   # { $ g p i o V a l u e } " 
 
     e n d 
 
 
 
     i f   $ p a y L o a d . n i l ?                                 # p a y l o a d L0zz`0c0_04XT
 
         i f   $ g p i o V a l u e   = =   0 
 
             g p i o . w r i t e   1 
 
             $ g p i o V a l u e   =   1 
 
         e l s i f   $ g p i o V a l u e   = =   1 
 
             g p i o . w r i t e   0 
 
             $ g p i o V a l u e   =   0 
 
         e n d 
 
     e l s e                                                           # p a y l o a d k0pe$PL0eQc0f0D0_04XT
 
         i f   $ g p i o V a l u e   = =   0 
 
             g p i o . w r i t e   $ p a y L o a d 
 
             $ g p i o V a l u e   =   $ p a y L o a d 
 
         e l s e 
 
             g p i o . w r i t e   0 
 
             $ g p i o V a l u e   =   0 
 
         e n d 
 
     e n d 
 
 e n d 
 
 # = e n d 
 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 
 
 
 d e f   p r o c e s s _ n o d e _ g p i o r e a d ( n o d e ,   m s g ) 
 
     g p i o r e a d [ : w i r e s ] . e a c h   {   | n o d e | 
 
     m s g   =   { : i d   = >   n o d e , 
 
                   : G P I O T y p e   = >   g p i o r e a d [ : G P I O T y p e ] , 
 
                   : d i g i t a l   = >   g p i o r e a d [ : t a r g e t P o r t _ d i g i t a l ] , 
 
                   : A D C   = >   g p i o r e a d [ : t a r g e t P o r t _ A D C ] 
 
 
 
                 } 
 
     $ q u e u e   < <   m s g 
 
 
 
 } 
 
 e n d 
 
 
 
 d e f   p r o c e s s _ n o d e _ g p i o w r i t e ( n o d e ,   m s g ) 
 
     g p i o w r i t e [ : w i r e s ] . e a c h   {   | n o d e | 
 
     m s g   =   { : W r i t e T y p e   = >   g p i o w r i t e [ : W r i t e T y p e ] , 
 
                 : G P I O T y p e   = >   g p i o w r i t e [ : G P I O T y p e ] , 
 
                 : t a r g e t P o r t _ d i g i t a l   = >   g p i o w r i t e [ : t a r g e t P o r t _ d i g i t a l ] , 
 
                 : t a r g e t P o r t _ m o d e   = >   g p i o w r i t e [ : t a r g e t P o r t _ m o d e ] , 
 
                 : t a r g e t P o r t _ P W M   = >   g p i o w r i t e [ : t a r g e t P o r t _ P W M ] , 
 
                 : P W M _ n u m   = >   g p i o w r i t e [ : P W M _ n u m ] , 
 
                 : c y c l e   = >   g p i o w r i t e [ : c y c l e ] , 
 
                 : d o u b l e   = >   g p i o w r i t e [ : d o u b e ] , 
 
                 : t i m e   = >   g p i o w r i t e [ : t i m e ] , 
 
                 : r a t e   = >   g p i o w r i t e [ : r a t e ] 
 
                 } 
 
     $ q u e u e   < <   m s g 
 
 } 
 
 e n d 
 
 
 
 # 
 
 #   i n j e c t 
 
 # 
 
 d e f   p r o c e s s _ i n j e c t ( i n j e c t ) 
 
     i n j e c t [ : w i r e s ] . e a c h   {   | n o d e | 
 
         m s g   =   { : i d   = >   n o d e ,   : p a y l o a d   = >   i n j e c t [ : p a y l o a d ] } 
 
         $ q u e u e   < <   m s g 
 
     } 
 
 e n d 
 
 
 
 # 
 
 #   n o d e 
 
 # 
 
 d e f   p r o c e s s _ n o d e ( n o d e , m s g ) 
 
     c a s e   n o d e [ : t y p e ] 
 
     w h e n   : d e b u g 
 
         p u t s   m s g [ : p a y l o a d ] 
 
     w h e n   : s w i t c h 
 
         p r o c e s s _ n o d e _ s w i t c h   n o d e ,   m s g 
 
     w h e n   : g p i o 
 
         p r o c e s s _ n o d e _ g p i o   n o d e ,   m s g 
 
     w h e n   : c o n s t a n t 
 
         p r o c e s s _ n o d e _ c o n s t a n t   n o d e ,   m s g 
 
     w h e n   : g p i o r e a d 
 
         p r o c e s s _ n o d e _ g p i o r e a d   n o d e ,   m s g 
 
     w h e n   : g p i o w r i t e 
 
         p r o c e s s _ n o d e _ g p i o w r i t e   n o d e ,   m s g 
 
     w h e n   : i 2 c 
 
         p r o c e s s _ n o d e _ i 2 c   n o d e ,   m s g 
 
     w h e n   : p a r a m e t e r 
 
         p r o c e s s _ n o d e _ p a r a m e t e r   n o d e ,   m s g 
 
     w h e n   : f u n c t i o n _ c o d e 
 
         p r o c e s s _ n o d e _ f u n c t i o n _ c o d e   n o d e ,   m s g 
 
     e l s e 
 
         p u t s   " # { n o d e [ : t y p e ] }   i s   n o t   s u p p o r t e d " 
 
     e n d 
 
 e n d 
 
 
 
 
 
 i n j e c t s   =   i n j e c t s . m a p   {   | i n j e c t | 
 
     i n j e c t [ : c n t ]   =   i n j e c t [ : r e p e a t ] 
 
     i n j e c t 
 
 } 
 
 
 
 L o o p I n t e r v a l   =   0 . 0 5 
 
 
 
 $ q u e u e   =   [ ] 
 
 
 
 # p r o c e s s   n o d e 
 
 w h i l e   t r u e   d o 
 
     #   p r o c e s s   i n j e c t 
 
     i n j e c t s . e a c h _ i n d e x   {   | i d x | 
 
         i n j e c t s [ i d x ] [ : c n t ]   - =   L o o p I n t e r v a l 
 
         i f   i n j e c t s [ i d x ] [ : c n t ]   <   0   t h e n 
 
             i n j e c t s [ i d x ] [ : c n t ]   =   i n j e c t s [ i d x ] [ : r e p e a t ] 
 
             p r o c e s s _ i n j e c t   i n j e c t s [ i d x ] 
 
         e n d 
 
     } 
 
 
 
     #   p r o c e s s   q u e u e 
 
     m s g   =   $ q u e u e . f i r s t 
 
     i f   m s g   t h e n 
 
         $ q u e u e . d e l e t e _ a t   0 
 
         i d x   =   n o d e s . i n d e x   {   | v |   v [ : i d ] = = m s g [ : i d ]   } 
 
         i f   i d x   t h e n 
 
             p r o c e s s _ n o d e   n o d e s [ i d x ] ,   m s g 
 
         e n d 
 
     e n d 
 
 
 
     #   n e x t 
 
     #   p u t s   " q = # { $ q u e u e } " 
 
     s l e e p   L o o p I n t e r v a l 
 
 e n d 
 
 
