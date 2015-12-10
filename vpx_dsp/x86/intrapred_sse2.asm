;
;  Copyright (c) 2010 The WebM project authors. All Rights Reserved.
;
;  Use of this source code is governed by a BSD-style license
;  that can be found in the LICENSE file in the root of the source
;  tree. An additional intellectual property rights grant can be found
;  in the file PATENTS.  All contributing project authors may
;  be found in the AUTHORS file in the root of the source tree.
;

%include "third_party/x86inc/x86inc.asm"

SECTION_RODATA
pw_4:  times 8 dw 4
pw_8:  times 8 dw 8
pw_16: times 8 dw 16
pw_32: times 8 dw 32
dc_128: times 16 db 128
pw2_4:  times 8 dw 2
pw2_8:  times 8 dw 4
pw2_16:  times 8 dw 8
pw2_32:  times 8 dw 16

SECTION .text

INIT_XMM sse2
cglobal dc_predictor_4x4, 4, 5, 3, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  movd                  m2, [leftq]
  movd                  m0, [aboveq]
  pxor                  m1, m1
  punpckldq             m0, m2
  psadbw                m0, m1
  paddw                 m0, [GLOBAL(pw_4)]
  psraw                 m0, 3
  pshuflw               m0, m0, 0x0
  packuswb              m0, m0
  movd      [dstq        ], m0
  movd      [dstq+strideq], m0
  lea                 dstq, [dstq+strideq*2]
  movd      [dstq        ], m0
  movd      [dstq+strideq], m0

  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal dc_left_predictor_4x4, 2, 5, 2, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  movifnidn          leftq, leftmp
  pxor                  m1, m1
  movd                  m0, [leftq]
  psadbw                m0, m1
  paddw                 m0, [GLOBAL(pw2_4)]
  psraw                 m0, 2
  pshuflw               m0, m0, 0x0
  packuswb              m0, m0
  movd      [dstq        ], m0
  movd      [dstq+strideq], m0
  lea                 dstq, [dstq+strideq*2]
  movd      [dstq        ], m0
  movd      [dstq+strideq], m0

  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal dc_top_predictor_4x4, 3, 5, 2, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  movd                  m0, [aboveq]
  psadbw                m0, m1
  paddw                 m0, [GLOBAL(pw2_4)]
  psraw                 m0, 2
  pshuflw               m0, m0, 0x0
  packuswb              m0, m0
  movd      [dstq        ], m0
  movd      [dstq+strideq], m0
  lea                 dstq, [dstq+strideq*2]
  movd      [dstq        ], m0
  movd      [dstq+strideq], m0

  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal dc_predictor_8x8, 4, 5, 3, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  movq                  m0, [aboveq]
  movq                  m2, [leftq]
  DEFINE_ARGS dst, stride, stride3
  lea             stride3q, [strideq*3]
  psadbw                m0, m1
  psadbw                m2, m1
  paddw                 m0, m2
  paddw                 m0, [GLOBAL(pw_8)]
  psraw                 m0, 4
  punpcklbw             m0, m0
  pshuflw               m0, m0, 0x0
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0

  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal dc_top_predictor_8x8, 3, 5, 2, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  movq                  m0, [aboveq]
  DEFINE_ARGS dst, stride, stride3
  lea             stride3q, [strideq*3]
  psadbw                m0, m1
  paddw                 m0, [GLOBAL(pw2_8)]
  psraw                 m0, 3
  punpcklbw             m0, m0
  pshuflw               m0, m0, 0x0
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0

  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal dc_left_predictor_8x8, 2, 5, 2, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  movifnidn          leftq, leftmp
  pxor                  m1, m1
  movq                  m0, [leftq]
  DEFINE_ARGS dst, stride, stride3
  lea             stride3q, [strideq*3]
  psadbw                m0, m1
  paddw                 m0, [GLOBAL(pw2_8)]
  psraw                 m0, 3
  punpcklbw             m0, m0
  pshuflw               m0, m0, 0x0
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0

  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal dc_128_predictor_4x4, 2, 5, 1, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  DEFINE_ARGS dst, stride, stride3
  lea             stride3q, [strideq*3]
  movd     m0,        [GLOBAL(dc_128)]
  movd    [dstq          ], m0
  movd    [dstq+strideq  ], m0
  movd    [dstq+strideq*2], m0
  movd    [dstq+stride3q ], m0
  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal dc_128_predictor_8x8, 2, 5, 1, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  DEFINE_ARGS dst, stride, stride3
  lea             stride3q, [strideq*3]
  movq    m0,        [GLOBAL(dc_128)]
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0
  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal dc_predictor_16x16, 4, 5, 3, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  mova                  m0, [aboveq]
  mova                  m2, [leftq]
  DEFINE_ARGS dst, stride, stride3, lines4
  lea             stride3q, [strideq*3]
  mov              lines4d, 4
  psadbw                m0, m1
  psadbw                m2, m1
  paddw                 m0, m2
  movhlps               m2, m0
  paddw                 m0, m2
  paddw                 m0, [GLOBAL(pw_16)]
  psraw                 m0, 5
  pshuflw               m0, m0, 0x0
  punpcklqdq            m0, m0
  packuswb              m0, m0
.loop:
  mova    [dstq          ], m0
  mova    [dstq+strideq  ], m0
  mova    [dstq+strideq*2], m0
  mova    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  dec              lines4d
  jnz .loop

  RESTORE_GOT
  REP_RET


INIT_XMM sse2
cglobal dc_top_predictor_16x16, 4, 5, 3, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  pxor                  m2, m2
  mova                  m0, [aboveq]
  DEFINE_ARGS dst, stride, stride3, lines4
  lea             stride3q, [strideq*3]
  mov              lines4d, 4
  psadbw                m0, m1
  psadbw                m2, m1
  paddw                 m0, m2
  movhlps               m2, m0
  paddw                 m0, m2
  paddw                 m0, [GLOBAL(pw2_16)]
  psraw                 m0, 4
  pshuflw               m0, m0, 0x0
  punpcklqdq            m0, m0
  packuswb              m0, m0
.loop:
  mova    [dstq          ], m0
  mova    [dstq+strideq  ], m0
  mova    [dstq+strideq*2], m0
  mova    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  dec              lines4d
  jnz .loop

  RESTORE_GOT
  REP_RET

INIT_XMM sse2
cglobal dc_left_predictor_16x16, 4, 5, 3, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  pxor                  m2, m2
  mova                  m0, [leftq]
  DEFINE_ARGS dst, stride, stride3, lines4
  lea             stride3q, [strideq*3]
  mov              lines4d, 4
  psadbw                m0, m1
  psadbw                m2, m1
  paddw                 m0, m2
  movhlps               m2, m0
  paddw                 m0, m2
  paddw                 m0, [GLOBAL(pw2_16)]
  psraw                 m0, 4
  pshuflw               m0, m0, 0x0
  punpcklqdq            m0, m0
  packuswb              m0, m0
.loop:
  mova    [dstq          ], m0
  mova    [dstq+strideq  ], m0
  mova    [dstq+strideq*2], m0
  mova    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  dec              lines4d
  jnz .loop

  RESTORE_GOT
  REP_RET

INIT_XMM sse2
cglobal dc_128_predictor_16x16, 4, 5, 3, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  DEFINE_ARGS dst, stride, stride3, lines4
  lea             stride3q, [strideq*3]
  mov              lines4d, 4
  mova    m0,        [GLOBAL(dc_128)]
.loop:
  mova    [dstq          ], m0
  mova    [dstq+strideq  ], m0
  mova    [dstq+strideq*2], m0
  mova    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  dec              lines4d
  jnz .loop
  RESTORE_GOT
  RET


INIT_XMM sse2
cglobal dc_predictor_32x32, 4, 5, 5, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  mova                  m0, [aboveq]
  mova                  m2, [aboveq+16]
  mova                  m3, [leftq]
  mova                  m4, [leftq+16]
  DEFINE_ARGS dst, stride, stride3, lines4
  lea             stride3q, [strideq*3]
  mov              lines4d, 8
  psadbw                m0, m1
  psadbw                m2, m1
  psadbw                m3, m1
  psadbw                m4, m1
  paddw                 m0, m2
  paddw                 m0, m3
  paddw                 m0, m4
  movhlps               m2, m0
  paddw                 m0, m2
  paddw                 m0, [GLOBAL(pw_32)]
  psraw                 m0, 6
  pshuflw               m0, m0, 0x0
  punpcklqdq            m0, m0
  packuswb              m0, m0
.loop:
  mova [dstq             ], m0
  mova [dstq          +16], m0
  mova [dstq+strideq     ], m0
  mova [dstq+strideq  +16], m0
  mova [dstq+strideq*2   ], m0
  mova [dstq+strideq*2+16], m0
  mova [dstq+stride3q    ], m0
  mova [dstq+stride3q +16], m0
  lea                 dstq, [dstq+strideq*4]
  dec              lines4d
  jnz .loop

  RESTORE_GOT
  REP_RET

INIT_XMM sse2
cglobal dc_top_predictor_32x32, 4, 5, 5, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  mova                  m0, [aboveq]
  mova                  m2, [aboveq+16]
  DEFINE_ARGS dst, stride, stride3, lines4
  lea             stride3q, [strideq*3]
  mov              lines4d, 8
  psadbw                m0, m1
  psadbw                m2, m1
  paddw                 m0, m2
  movhlps               m2, m0
  paddw                 m0, m2
  paddw                 m0, [GLOBAL(pw2_32)]
  psraw                 m0, 5
  pshuflw               m0, m0, 0x0
  punpcklqdq            m0, m0
  packuswb              m0, m0
.loop:
  mova [dstq             ], m0
  mova [dstq          +16], m0
  mova [dstq+strideq     ], m0
  mova [dstq+strideq  +16], m0
  mova [dstq+strideq*2   ], m0
  mova [dstq+strideq*2+16], m0
  mova [dstq+stride3q    ], m0
  mova [dstq+stride3q +16], m0
  lea                 dstq, [dstq+strideq*4]
  dec              lines4d
  jnz .loop

  RESTORE_GOT
  REP_RET

INIT_XMM sse2
cglobal dc_left_predictor_32x32, 4, 5, 5, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  pxor                  m1, m1
  mova                  m0, [leftq]
  mova                  m2, [leftq+16]
  DEFINE_ARGS dst, stride, stride3, lines4
  lea             stride3q, [strideq*3]
  mov              lines4d, 8
  psadbw                m0, m1
  psadbw                m2, m1
  paddw                 m0, m2
  movhlps               m2, m0
  paddw                 m0, m2
  paddw                 m0, [GLOBAL(pw2_32)]
  psraw                 m0, 5
  pshuflw               m0, m0, 0x0
  punpcklqdq            m0, m0
  packuswb              m0, m0
.loop:
  mova [dstq             ], m0
  mova [dstq          +16], m0
  mova [dstq+strideq     ], m0
  mova [dstq+strideq  +16], m0
  mova [dstq+strideq*2   ], m0
  mova [dstq+strideq*2+16], m0
  mova [dstq+stride3q    ], m0
  mova [dstq+stride3q +16], m0
  lea                 dstq, [dstq+strideq*4]
  dec              lines4d
  jnz .loop

  RESTORE_GOT
  REP_RET

INIT_XMM sse2
cglobal dc_128_predictor_32x32, 4, 5, 3, dst, stride, above, left, goffset
  GET_GOT     goffsetq

  DEFINE_ARGS dst, stride, stride3, lines4
  lea             stride3q, [strideq*3]
  mov              lines4d, 8
  mova    m0,        [GLOBAL(dc_128)]
.loop:
  mova [dstq             ], m0
  mova [dstq          +16], m0
  mova [dstq+strideq     ], m0
  mova [dstq+strideq  +16], m0
  mova [dstq+strideq*2   ], m0
  mova [dstq+strideq*2+16], m0
  mova [dstq+stride3q    ], m0
  mova [dstq+stride3q +16], m0
  lea                 dstq, [dstq+strideq*4]
  dec              lines4d
  jnz .loop
  RESTORE_GOT
  RET

INIT_XMM sse2
cglobal v_predictor_4x4, 3, 3, 1, dst, stride, above
  movd                  m0, [aboveq]
  movd      [dstq        ], m0
  movd      [dstq+strideq], m0
  lea                 dstq, [dstq+strideq*2]
  movd      [dstq        ], m0
  movd      [dstq+strideq], m0
  RET

INIT_XMM sse2
cglobal v_predictor_8x8, 3, 3, 1, dst, stride, above
  movq                  m0, [aboveq]
  DEFINE_ARGS dst, stride, stride3
  lea             stride3q, [strideq*3]
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  movq    [dstq          ], m0
  movq    [dstq+strideq  ], m0
  movq    [dstq+strideq*2], m0
  movq    [dstq+stride3q ], m0
  RET

INIT_XMM sse2
cglobal v_predictor_16x16, 3, 4, 1, dst, stride, above
  mova                  m0, [aboveq]
  DEFINE_ARGS dst, stride, stride3, nlines4
  lea             stride3q, [strideq*3]
  mov              nlines4d, 4
.loop:
  mova    [dstq          ], m0
  mova    [dstq+strideq  ], m0
  mova    [dstq+strideq*2], m0
  mova    [dstq+stride3q ], m0
  lea                 dstq, [dstq+strideq*4]
  dec             nlines4d
  jnz .loop
  REP_RET

INIT_XMM sse2
cglobal v_predictor_32x32, 3, 4, 2, dst, stride, above
  mova                  m0, [aboveq]
  mova                  m1, [aboveq+16]
  DEFINE_ARGS dst, stride, stride3, nlines4
  lea             stride3q, [strideq*3]
  mov              nlines4d, 8
.loop:
  mova [dstq             ], m0
  mova [dstq          +16], m1
  mova [dstq+strideq     ], m0
  mova [dstq+strideq  +16], m1
  mova [dstq+strideq*2   ], m0
  mova [dstq+strideq*2+16], m1
  mova [dstq+stride3q    ], m0
  mova [dstq+stride3q +16], m1
  lea                 dstq, [dstq+strideq*4]
  dec             nlines4d
  jnz .loop
  REP_RET

INIT_XMM sse2
cglobal h_predictor_4x4, 2, 4, 4, dst, stride, line, left
  movifnidn          leftq, leftmp
  movd                  m0, [leftq]
  punpcklbw             m0, m0
  punpcklbw             m0, m0
  pshufd                m1, m0, 0x1
  movd      [dstq        ], m0
  movd      [dstq+strideq], m1
  pshufd                m2, m0, 0x2
  lea                 dstq, [dstq+strideq*2]
  pshufd                m3, m0, 0x3
  movd      [dstq        ], m2
  movd      [dstq+strideq], m3
  RET

INIT_XMM sse2
cglobal h_predictor_8x8, 2, 5, 3, dst, stride, line, left
  movifnidn          leftq, leftmp
  mov                lineq, -2
  DEFINE_ARGS  dst, stride, line, left, stride3
  lea             stride3q, [strideq*3]
  movq                  m0, [leftq    ]
  punpcklbw             m0, m0              ; l1 l1 l2 l2 ... l8 l8
.loop:
  pshuflw               m1, m0, 0x0         ; l1 l1 l1 l1 l1 l1 l1 l1
  pshuflw               m2, m0, 0x55        ; l2 l2 l2 l2 l2 l2 l2 l2
  movq      [dstq        ], m1
  movq      [dstq+strideq], m2
  pshuflw               m1, m0, 0xaa
  pshuflw               m2, m0, 0xff
  movq    [dstq+strideq*2], m1
  movq    [dstq+stride3q ], m2
  pshufd                m0, m0, 0xe         ; [63:0] l5 l5 l6 l6 l7 l7 l8 l8
  inc                lineq
  lea                 dstq, [dstq+strideq*4]
  jnz .loop
  REP_RET

INIT_XMM sse2
cglobal h_predictor_16x16, 2, 5, 3, dst, stride, line, left
  movifnidn          leftq, leftmp
  mov                lineq, -4
  DEFINE_ARGS dst, stride, line, left, stride3
  lea             stride3q, [strideq*3]
.loop:
  movd                  m0, [leftq]
  punpcklbw             m0, m0
  punpcklbw             m0, m0              ; l1 to l4 each repeated 4 times
  pshufd            m1, m0, 0x0             ; l1 repeated 16 times
  pshufd            m2, m0, 0x55            ; l2 repeated 16 times
  mova    [dstq          ], m1
  mova    [dstq+strideq  ], m2
  pshufd            m1, m0, 0xaa
  pshufd            m2, m0, 0xff
  mova    [dstq+strideq*2], m1
  mova    [dstq+stride3q ], m2
  inc                lineq
  lea                leftq, [leftq+4       ]
  lea                 dstq, [dstq+strideq*4]
  jnz .loop
  REP_RET

INIT_XMM sse2
cglobal h_predictor_32x32, 2, 5, 3, dst, stride, line, left
  movifnidn              leftq, leftmp
  mov                    lineq, -8
  DEFINE_ARGS dst, stride, line, left, stride3
  lea                 stride3q, [strideq*3]
.loop:
  movd                      m0, [leftq]
  punpcklbw                 m0, m0
  punpcklbw                 m0, m0              ; l1 to l4 each repeated 4 times
  pshufd                m1, m0, 0x0             ; l1 repeated 16 times
  pshufd                m2, m0, 0x55            ; l2 repeated 16 times
  mova     [dstq             ], m1
  mova     [dstq+16          ], m1
  mova     [dstq+strideq     ], m2
  mova     [dstq+strideq+16  ], m2
  pshufd                m1, m0, 0xaa
  pshufd                m2, m0, 0xff
  mova     [dstq+strideq*2   ], m1
  mova     [dstq+strideq*2+16], m1
  mova     [dstq+stride3q    ], m2
  mova     [dstq+stride3q+16 ], m2
  inc                    lineq
  lea                    leftq, [leftq+4       ]
  lea                     dstq, [dstq+strideq*4]
  jnz .loop
  REP_RET

INIT_XMM sse2
cglobal tm_predictor_4x4, 4, 4, 5, dst, stride, above, left
  pxor                  m1, m1
  movq                  m0, [aboveq-1]; [63:0] tl t1 t2 t3 t4 x x x
  punpcklbw             m0, m1
  pshuflw               m2, m0, 0x0   ; [63:0] tl tl tl tl [word]
  psrldq                m0, 2
  psubw                 m0, m2        ; [63:0] t1-tl t2-tl t3-tl t4-tl [word]
  movd                  m2, [leftq]
  punpcklbw             m2, m1
  pshuflw               m4, m2, 0x0   ; [63:0] l1 l1 l1 l1 [word]
  pshuflw               m3, m2, 0x55  ; [63:0] l2 l2 l2 l2 [word]
  paddw                 m4, m0
  paddw                 m3, m0
  packuswb              m4, m4
  packuswb              m3, m3
  movd      [dstq        ], m4
  movd      [dstq+strideq], m3
  lea                 dstq, [dstq+strideq*2]
  pshuflw               m4, m2, 0xaa
  pshuflw               m3, m2, 0xff
  paddw                 m4, m0
  paddw                 m3, m0
  packuswb              m4, m4
  packuswb              m3, m3
  movd      [dstq        ], m4
  movd      [dstq+strideq], m3
  RET

INIT_XMM sse2
cglobal tm_predictor_8x8, 4, 4, 5, dst, stride, above, left
  pxor                  m1, m1
  movd                  m2, [aboveq-1]
  movq                  m0, [aboveq]
  punpcklbw             m2, m1
  punpcklbw             m0, m1        ; t1 t2 t3 t4 t5 t6 t7 t8 [word]
  pshuflw               m2, m2, 0x0   ; [63:0] tl tl tl tl [word]
  DEFINE_ARGS dst, stride, line, left
  mov                lineq, -4
  punpcklqdq            m2, m2        ; tl tl tl tl tl tl tl tl [word]
  psubw                 m0, m2        ; t1-tl t2-tl ... t8-tl [word]
  movq                  m2, [leftq]
  punpcklbw             m2, m1        ; l1 l2 l3 l4 l5 l6 l7 l8 [word]
.loop
  pshuflw               m4, m2, 0x0   ; [63:0] l1 l1 l1 l1 [word]
  pshuflw               m3, m2, 0x55  ; [63:0] l2 l2 l2 l2 [word]
  punpcklqdq            m4, m4        ; l1 l1 l1 l1 l1 l1 l1 l1 [word]
  punpcklqdq            m3, m3        ; l2 l2 l2 l2 l2 l2 l2 l2 [word]
  paddw                 m4, m0
  paddw                 m3, m0
  packuswb              m4, m3
  movq      [dstq        ], m4
  movhps    [dstq+strideq], m4
  lea                 dstq, [dstq+strideq*2]
  psrldq                m2, 4
  inc                lineq
  jnz .loop
  REP_RET

INIT_XMM sse2
cglobal tm_predictor_16x16, 4, 4, 7, dst, stride, above, left
  pxor                  m1, m1
  movd                  m2, [aboveq-1]
  mova                  m0, [aboveq]
  punpcklbw             m2, m1
  punpckhbw             m4, m0, m1
  punpcklbw             m0, m1
  pshuflw               m2, m2, 0x0
  DEFINE_ARGS dst, stride, line, left
  mov                lineq, -8
  punpcklqdq            m2, m2
  add                leftq, 16
  psubw                 m0, m2
  psubw                 m4, m2
.loop:
  movd                  m2, [leftq+lineq*2]
  movd                  m3, [leftq+lineq*2+1]
  punpcklbw             m2, m1
  punpcklbw             m3, m1
  pshuflw               m2, m2, 0x0
  pshuflw               m3, m3, 0x0
  punpcklqdq            m2, m2
  punpcklqdq            m3, m3
  paddw                 m5, m2, m0
  paddw                 m6, m3, m0
  paddw                 m2, m4
  paddw                 m3, m4
  packuswb              m5, m2
  packuswb              m6, m3
  mova      [dstq        ], m5
  mova      [dstq+strideq], m6
  lea                 dstq, [dstq+strideq*2]
  inc                lineq
  jnz .loop
  REP_RET

%if ARCH_X86_64
INIT_XMM sse2
cglobal tm_predictor_32x32, 4, 4, 10, dst, stride, above, left
  pxor                  m1, m1
  movd                  m2, [aboveq-1]
  mova                  m0, [aboveq]
  mova                  m4, [aboveq+16]
  punpcklbw             m2, m1
  punpckhbw             m3, m0, m1
  punpckhbw             m5, m4, m1
  punpcklbw             m0, m1
  punpcklbw             m4, m1
  pshuflw               m2, m2, 0x0
  DEFINE_ARGS dst, stride, line, left
  mov                lineq, -16
  punpcklqdq            m2, m2
  add                leftq, 32
  psubw                 m0, m2
  psubw                 m3, m2
  psubw                 m4, m2
  psubw                 m5, m2
.loop:
  movd                  m2, [leftq+lineq*2]
  movd                  m6, [leftq+lineq*2+1]
  punpcklbw             m2, m1
  punpcklbw             m6, m1
  pshuflw               m2, m2, 0x0
  pshuflw               m6, m6, 0x0
  punpcklqdq            m2, m2
  punpcklqdq            m6, m6
  paddw                 m7, m2, m0
  paddw                 m8, m2, m3
  paddw                 m9, m2, m4
  paddw                 m2, m5
  packuswb              m7, m8
  packuswb              m9, m2
  paddw                 m2, m6, m0
  paddw                 m8, m6, m3
  mova   [dstq           ], m7
  paddw                 m7, m6, m4
  paddw                 m6, m5
  mova   [dstq        +16], m9
  packuswb              m2, m8
  packuswb              m7, m6
  mova   [dstq+strideq   ], m2
  mova   [dstq+strideq+16], m7
  lea                 dstq, [dstq+strideq*2]
  inc                lineq
  jnz .loop
  REP_RET
%endif
