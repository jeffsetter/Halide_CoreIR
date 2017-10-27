	.text
	.syntax unified
	.eabi_attribute	67, "2.09"	@ Tag_conformance
	.cpu	cortex-a9
	.eabi_attribute	6, 10	@ Tag_CPU_arch
	.eabi_attribute	7, 65	@ Tag_CPU_arch_profile
	.eabi_attribute	8, 1	@ Tag_ARM_ISA_use
	.eabi_attribute	9, 2	@ Tag_THUMB_ISA_use
	.fpu	neon-fp16
	.eabi_attribute	15, 1	@ Tag_ABI_PCS_RW_data
	.eabi_attribute	16, 1	@ Tag_ABI_PCS_RO_data
	.eabi_attribute	17, 2	@ Tag_ABI_PCS_GOT_use
	.eabi_attribute	20, 2	@ Tag_ABI_FP_denormal
	.eabi_attribute	23, 1	@ Tag_ABI_FP_number_model
	.eabi_attribute	34, 1	@ Tag_CPU_unaligned_access
	.eabi_attribute	24, 1	@ Tag_ABI_align_needed
	.eabi_attribute	25, 1	@ Tag_ABI_align_preserved
	.eabi_attribute	28, 1	@ Tag_ABI_VFP_args
	.eabi_attribute	36, 1	@ Tag_FP_HP_extension
	.eabi_attribute	38, 1	@ Tag_ABI_FP_16bit_format
	.eabi_attribute	42, 1	@ Tag_MPextension_use
	.eabi_attribute	14, 0	@ Tag_ABI_PCS_R9_use
	.eabi_attribute	68, 1	@ Tag_Virtualization_use
	.file	"pipeline_zynq"
	.section	.text._ZN6Halide7Runtime8Internal14default_mallocEPvj,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal14default_mallocEPvj
	.align	2
	.type	_ZN6Halide7Runtime8Internal14default_mallocEPvj,%function
_ZN6Halide7Runtime8Internal14default_mallocEPvj: @ @_ZN6Halide7Runtime8Internal14default_mallocEPvj
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	.setfp	r11, sp
	mov	r11, sp
	add	r0, r1, #128
	bl	malloc(PLT)
	mov	r1, r0
	mov	r0, #0
	cmp	r1, #0
	beq	.LBB0_2
@ BB#1:
	add	r0, r1, #131
	bfc	r0, #0, #7
	str	r1, [r0, #-4]
.LBB0_2:
	pop	{r11, pc}
.Lfunc_end0:
	.size	_ZN6Halide7Runtime8Internal14default_mallocEPvj, .Lfunc_end0-_ZN6Halide7Runtime8Internal14default_mallocEPvj
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal12default_freeEPvS2_,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal12default_freeEPvS2_
	.align	2
	.type	_ZN6Halide7Runtime8Internal12default_freeEPvS2_,%function
_ZN6Halide7Runtime8Internal12default_freeEPvS2_: @ @_ZN6Halide7Runtime8Internal12default_freeEPvS2_
	.fnstart
@ BB#0:
	ldr	r0, [r1, #-4]
	b	free(PLT)
.Lfunc_end1:
	.size	_ZN6Halide7Runtime8Internal12default_freeEPvS2_, .Lfunc_end1-_ZN6Halide7Runtime8Internal12default_freeEPvS2_
	.cantunwind
	.fnend

	.section	.text.halide_set_custom_malloc,"ax",%progbits
	.weak	halide_set_custom_malloc
	.align	2
	.type	halide_set_custom_malloc,%function
halide_set_custom_malloc:               @ @halide_set_custom_malloc
	.fnstart
@ BB#0:
	ldr	r2, .LCPI2_1
	ldr	r1, .LCPI2_0
.LPC2_0:
	add	r2, pc, r2
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	str	r0, [r2]
	mov	r0, r1
	bx	lr
	.align	2
@ BB#1:
.LCPI2_0:
	.long	_ZN6Halide7Runtime8Internal13custom_mallocE(GOT)
.LCPI2_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC2_0+8)
.Lfunc_end2:
	.size	halide_set_custom_malloc, .Lfunc_end2-halide_set_custom_malloc
	.cantunwind
	.fnend

	.section	.text.halide_set_custom_free,"ax",%progbits
	.weak	halide_set_custom_free
	.align	2
	.type	halide_set_custom_free,%function
halide_set_custom_free:                 @ @halide_set_custom_free
	.fnstart
@ BB#0:
	ldr	r2, .LCPI3_1
	ldr	r1, .LCPI3_0
.LPC3_0:
	add	r2, pc, r2
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	str	r0, [r2]
	mov	r0, r1
	bx	lr
	.align	2
@ BB#1:
.LCPI3_0:
	.long	_ZN6Halide7Runtime8Internal11custom_freeE(GOT)
.LCPI3_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC3_0+8)
.Lfunc_end3:
	.size	halide_set_custom_free, .Lfunc_end3-halide_set_custom_free
	.cantunwind
	.fnend

	.section	.text.halide_malloc,"ax",%progbits
	.weak	halide_malloc
	.align	2
	.type	halide_malloc,%function
halide_malloc:                          @ @halide_malloc
	.fnstart
@ BB#0:
	ldr	r3, .LCPI4_1
	ldr	r2, .LCPI4_0
.LPC4_0:
	add	r3, pc, r3
	ldr	r2, [r2, r3]
	ldr	r2, [r2]
	bx	r2
	.align	2
@ BB#1:
.LCPI4_0:
	.long	_ZN6Halide7Runtime8Internal13custom_mallocE(GOT)
.LCPI4_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC4_0+8)
.Lfunc_end4:
	.size	halide_malloc, .Lfunc_end4-halide_malloc
	.cantunwind
	.fnend

	.section	.text.halide_free,"ax",%progbits
	.weak	halide_free
	.align	2
	.type	halide_free,%function
halide_free:                            @ @halide_free
	.fnstart
@ BB#0:
	ldr	r3, .LCPI5_1
	ldr	r2, .LCPI5_0
.LPC5_0:
	add	r3, pc, r3
	ldr	r2, [r2, r3]
	ldr	r2, [r2]
	bx	r2
	.align	2
@ BB#1:
.LCPI5_0:
	.long	_ZN6Halide7Runtime8Internal11custom_freeE(GOT)
.LCPI5_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC5_0+8)
.Lfunc_end5:
	.size	halide_free, .Lfunc_end5-halide_free
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal21default_error_handlerEPvPKc,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal21default_error_handlerEPvPKc
	.align	2
	.type	_ZN6Halide7Runtime8Internal21default_error_handlerEPvPKc,%function
_ZN6Halide7Runtime8Internal21default_error_handlerEPvPKc: @ @_ZN6Halide7Runtime8Internal21default_error_handlerEPvPKc
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	.pad	#4096
	sub	sp, sp, #4096
	ldr	r2, .LCPI6_1
	mov	r5, r1
	mov	r4, r0
	ldr	r1, .LCPI6_0
	movw	r3, #4094
	mov	r0, sp
.LPC6_0:
	add	r2, pc, r2
	add	r6, r0, r3
	add	r2, r1, r2
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r6
	mov	r2, r5
	bl	halide_string_to_string(PLT)
	ldrb	r1, [r0, #-1]
	cmp	r1, #10
	beq	.LBB6_2
@ BB#1:
	mov	r1, #10
	strh	r1, [r0]
.LBB6_2:
	mov	r1, sp
	mov	r0, r4
	bl	halide_print(PLT)
	bl	abort(PLT)
	sub	sp, r11, #16
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#3:
.LCPI6_0:
	.long	.L.str(GOTOFF)
.LCPI6_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC6_0+8)
.Lfunc_end6:
	.size	_ZN6Halide7Runtime8Internal21default_error_handlerEPvPKc, .Lfunc_end6-_ZN6Halide7Runtime8Internal21default_error_handlerEPvPKc
	.cantunwind
	.fnend

	.section	.text.halide_error,"ax",%progbits
	.weak	halide_error
	.align	2
	.type	halide_error,%function
halide_error:                           @ @halide_error
	.fnstart
@ BB#0:
	ldr	r3, .LCPI7_1
	ldr	r2, .LCPI7_0
.LPC7_0:
	add	r3, pc, r3
	ldr	r2, [r2, r3]
	ldr	r2, [r2]
	bx	r2
	.align	2
@ BB#1:
.LCPI7_0:
	.long	_ZN6Halide7Runtime8Internal13error_handlerE(GOT)
.LCPI7_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC7_0+8)
.Lfunc_end7:
	.size	halide_error, .Lfunc_end7-halide_error
	.cantunwind
	.fnend

	.section	.text.halide_set_error_handler,"ax",%progbits
	.weak	halide_set_error_handler
	.align	2
	.type	halide_set_error_handler,%function
halide_set_error_handler:               @ @halide_set_error_handler
	.fnstart
@ BB#0:
	ldr	r2, .LCPI8_1
	ldr	r1, .LCPI8_0
.LPC8_0:
	add	r2, pc, r2
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	str	r0, [r2]
	mov	r0, r1
	bx	lr
	.align	2
@ BB#1:
.LCPI8_0:
	.long	_ZN6Halide7Runtime8Internal13error_handlerE(GOT)
.LCPI8_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC8_0+8)
.Lfunc_end8:
	.size	halide_set_error_handler, .Lfunc_end8-halide_set_error_handler
	.cantunwind
	.fnend

	.section	.text.halide_print,"ax",%progbits
	.weak	halide_print
	.align	2
	.type	halide_print,%function
halide_print:                           @ @halide_print
	.fnstart
@ BB#0:
	ldr	r3, .LCPI9_1
	ldr	r2, .LCPI9_0
.LPC9_0:
	add	r3, pc, r3
	ldr	r2, [r2, r3]
	ldr	r2, [r2]
	bx	r2
	.align	2
@ BB#1:
.LCPI9_0:
	.long	_ZN6Halide7Runtime8Internal12custom_printE(GOT)
.LCPI9_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC9_0+8)
.Lfunc_end9:
	.size	halide_print, .Lfunc_end9-halide_print
	.cantunwind
	.fnend

	.section	.text.halide_set_custom_print,"ax",%progbits
	.weak	halide_set_custom_print
	.align	2
	.type	halide_set_custom_print,%function
halide_set_custom_print:                @ @halide_set_custom_print
	.fnstart
@ BB#0:
	ldr	r2, .LCPI10_1
	ldr	r1, .LCPI10_0
.LPC10_0:
	add	r2, pc, r2
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	str	r0, [r2]
	mov	r0, r1
	bx	lr
	.align	2
@ BB#1:
.LCPI10_0:
	.long	_ZN6Halide7Runtime8Internal12custom_printE(GOT)
.LCPI10_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC10_0+8)
.Lfunc_end10:
	.size	halide_set_custom_print, .Lfunc_end10-halide_set_custom_print
	.cantunwind
	.fnend

	.section	.text.halide_start_clock,"ax",%progbits
	.weak	halide_start_clock
	.align	2
	.type	halide_start_clock,%function
halide_start_clock:                     @ @halide_start_clock
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	ldr	r0, .LCPI11_1
	ldr	r4, .LCPI11_0
.LPC11_0:
	add	r0, pc, r0
	ldr	r0, [r4, r0]
	ldrb	r0, [r0]
	cmp	r0, #0
	bne	.LBB11_2
@ BB#1:
	ldr	r1, .LCPI11_3
	ldr	r0, .LCPI11_2
.LPC11_1:
	add	r5, pc, r1
	mov	r1, #0
	ldr	r0, [r0, r5]
	bl	gettimeofday(PLT)
	ldr	r0, [r4, r5]
	mov	r1, #1
	strb	r1, [r0]
.LBB11_2:
	mov	r0, #0
	pop	{r4, r5, r11, pc}
	.align	2
@ BB#3:
.LCPI11_0:
	.long	_ZN6Halide7Runtime8Internal29halide_reference_clock_initedE(GOT)
.LCPI11_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC11_0+8)
.LCPI11_2:
	.long	_ZN6Halide7Runtime8Internal22halide_reference_clockE(GOT)
.LCPI11_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC11_1+8)
.Lfunc_end11:
	.size	halide_start_clock, .Lfunc_end11-halide_start_clock
	.cantunwind
	.fnend

	.section	.text.halide_current_time_ns,"ax",%progbits
	.weak	halide_current_time_ns
	.align	2
	.type	halide_current_time_ns,%function
halide_current_time_ns:                 @ @halide_current_time_ns
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	.setfp	r11, sp
	mov	r11, sp
	.pad	#8
	sub	sp, sp, #8
	mov	r0, sp
	mov	r1, #0
	bl	gettimeofday(PLT)
	ldr	r1, .LCPI12_1
	ldr	r0, .LCPI12_0
.LPC12_0:
	add	r1, pc, r1
	ldr	r2, [sp, #4]
	ldr	r12, [sp]
	ldr	r0, [r0, r1]
	asr	r1, r2, #31
	ldr	r3, [r0]
	ldr	r0, [r0, #4]
	subs	r2, r2, r0
	sbc	r1, r1, r0, asr #31
	sub	r0, r12, r3
	movw	r3, #16960
	movt	r3, #15
	smlal	r2, r1, r0, r3
	mov	r3, #1000
	umull	r0, r2, r2, r3
	mla	r1, r1, r3, r2
	mov	sp, r11
	pop	{r11, pc}
	.align	2
@ BB#1:
.LCPI12_0:
	.long	_ZN6Halide7Runtime8Internal22halide_reference_clockE(GOT)
.LCPI12_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC12_0+8)
.Lfunc_end12:
	.size	halide_current_time_ns, .Lfunc_end12-halide_current_time_ns
	.cantunwind
	.fnend

	.section	.text.halide_sleep_ms,"ax",%progbits
	.weak	halide_sleep_ms
	.align	2
	.type	halide_sleep_ms,%function
halide_sleep_ms:                        @ @halide_sleep_ms
	.fnstart
@ BB#0:
	mov	r0, #1000
	mul	r0, r1, r0
	b	usleep(PLT)
.Lfunc_end13:
	.size	halide_sleep_ms, .Lfunc_end13-halide_sleep_ms
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal17halide_print_implEPvPKc,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal17halide_print_implEPvPKc
	.align	2
	.type	_ZN6Halide7Runtime8Internal17halide_print_implEPvPKc,%function
_ZN6Halide7Runtime8Internal17halide_print_implEPvPKc: @ @_ZN6Halide7Runtime8Internal17halide_print_implEPvPKc
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r1
	mov	r0, r4
	bl	strlen(PLT)
	mov	r2, r0
	mov	r0, #2
	mov	r1, r4
	pop	{r4, r10, r11, lr}
	b	write(PLT)
.Lfunc_end14:
	.size	_ZN6Halide7Runtime8Internal17halide_print_implEPvPKc, .Lfunc_end14-_ZN6Halide7Runtime8Internal17halide_print_implEPvPKc
	.cantunwind
	.fnend

	.section	.text.halide_create_temp_file,"ax",%progbits
	.weak	halide_create_temp_file
	.align	2
	.type	halide_create_temp_file,%function
halide_create_temp_file:                @ @halide_create_temp_file
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r7, r1
	mov	r9, r3
	mov	r6, r2
	mvn	r8, #21
	cmp	r7, #0
	beq	.LBB15_6
@ BB#1:
	cmp	r6, #0
	beq	.LBB15_6
@ BB#2:
	cmp	r9, #0
	beq	.LBB15_6
@ BB#3:
	ldr	r0, .LCPI15_0
	ldr	r1, .LCPI15_1
.LPC15_0:
	add	r10, pc, r0
	add	r0, r1, r10
	bl	strlen(PLT)
	mov	r4, r0
	mov	r0, r7
	bl	strlen(PLT)
	ldr	r1, .LCPI15_2
	mov	r5, r0
	add	r0, r1, r10
	mov	r10, r1
	bl	strlen(PLT)
	add	r1, r4, r5
	add	r4, r1, r0
	mov	r0, r6
	bl	strlen(PLT)
	ldr	r1, [r11, #8]
	add	r0, r4, r0
	add	r0, r0, #1
	cmp	r0, r1
	bhi	.LBB15_6
@ BB#4:
	ldr	r0, .LCPI15_3
.LPC15_1:
	add	r5, pc, r0
	ldr	r0, .LCPI15_1
	add	r2, r0, r5
	add	r0, r9, r1
	sub	r4, r0, #1
	mov	r0, r9
	mov	r1, r4
	bl	halide_string_to_string(PLT)
	mov	r1, r4
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	add	r2, r10, r5
	mov	r1, r4
	bl	halide_string_to_string(PLT)
	mov	r1, r4
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	strb	r1, [r0]
	mov	r0, r6
	bl	strlen(PLT)
	mov	r1, r0
	mov	r0, r9
	bl	mkstemps(PLT)
	cmn	r0, #1
	beq	.LBB15_6
@ BB#5:
	bl	close(PLT)
	mov	r8, #0
.LBB15_6:
	mov	r0, r8
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#7:
.LCPI15_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC15_0+8)
.LCPI15_1:
	.long	.L.str.7(GOTOFF)
.LCPI15_2:
	.long	.L.str.1(GOTOFF)
.LCPI15_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC15_1+8)
.Lfunc_end15:
	.size	halide_create_temp_file, .Lfunc_end15-halide_create_temp_file
	.cantunwind
	.fnend

	.section	.text.halide_host_cpu_count,"ax",%progbits
	.weak	halide_host_cpu_count
	.align	2
	.type	halide_host_cpu_count,%function
halide_host_cpu_count:                  @ @halide_host_cpu_count
	.fnstart
@ BB#0:
	mov	r0, #84
	b	sysconf(PLT)
.Lfunc_end16:
	.size	halide_host_cpu_count, .Lfunc_end16-halide_host_cpu_count
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal19spawn_thread_helperEPv,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal19spawn_thread_helperEPv
	.align	2
	.type	_ZN6Halide7Runtime8Internal19spawn_thread_helperEPv,%function
_ZN6Halide7Runtime8Internal19spawn_thread_helperEPv: @ @_ZN6Halide7Runtime8Internal19spawn_thread_helperEPv
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	.setfp	r11, sp
	mov	r11, sp
	ldr	r1, [r0]
	ldr	r0, [r0, #4]
	blx	r1
	mov	r0, #0
	pop	{r11, pc}
.Lfunc_end17:
	.size	_ZN6Halide7Runtime8Internal19spawn_thread_helperEPv, .Lfunc_end17-_ZN6Halide7Runtime8Internal19spawn_thread_helperEPv
	.cantunwind
	.fnend

	.section	.text.halide_spawn_thread,"ax",%progbits
	.weak	halide_spawn_thread
	.align	2
	.type	halide_spawn_thread,%function
halide_spawn_thread:                    @ @halide_spawn_thread
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r5, r0
	mov	r0, #12
	mov	r4, r1
	bl	malloc(PLT)
	mov	r6, r0
	ldr	r1, .LCPI18_1
	ldr	r0, .LCPI18_0
	mov	r3, r6
.LPC18_0:
	add	r1, pc, r1
	str	r5, [r6]
	str	r4, [r6, #4]
	ldr	r2, [r0, r1]
	mov	r1, #0
	mov	r0, r6
	str	r1, [r0, #8]!
	mov	r1, #0
	bl	pthread_create(PLT)
	mov	r0, r6
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#1:
.LCPI18_0:
	.long	_ZN6Halide7Runtime8Internal19spawn_thread_helperEPv(GOT)
.LCPI18_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC18_0+8)
.Lfunc_end18:
	.size	halide_spawn_thread, .Lfunc_end18-halide_spawn_thread
	.cantunwind
	.fnend

	.section	.text.halide_join_thread,"ax",%progbits
	.weak	halide_join_thread
	.align	2
	.type	halide_join_thread,%function
halide_join_thread:                     @ @halide_join_thread
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	.pad	#8
	sub	sp, sp, #8
	mov	r4, r0
	mov	r0, #0
	str	r0, [sp, #4]
	add	r1, sp, #4
	ldr	r0, [r4, #8]
	bl	pthread_join(PLT)
	mov	r0, r4
	bl	free(PLT)
	sub	sp, r11, #8
	pop	{r4, r10, r11, pc}
.Lfunc_end19:
	.size	halide_join_thread, .Lfunc_end19-halide_join_thread
	.cantunwind
	.fnend

	.section	.text.halide_mutex_lock,"ax",%progbits
	.weak	halide_mutex_lock
	.align	2
	.type	halide_mutex_lock,%function
halide_mutex_lock:                      @ @halide_mutex_lock
	.fnstart
@ BB#0:
	b	pthread_mutex_lock(PLT)
.Lfunc_end20:
	.size	halide_mutex_lock, .Lfunc_end20-halide_mutex_lock
	.cantunwind
	.fnend

	.section	.text.halide_mutex_unlock,"ax",%progbits
	.weak	halide_mutex_unlock
	.align	2
	.type	halide_mutex_unlock,%function
halide_mutex_unlock:                    @ @halide_mutex_unlock
	.fnstart
@ BB#0:
	b	pthread_mutex_unlock(PLT)
.Lfunc_end21:
	.size	halide_mutex_unlock, .Lfunc_end21-halide_mutex_unlock
	.cantunwind
	.fnend

	.section	.text.halide_mutex_destroy,"ax",%progbits
	.weak	halide_mutex_destroy
	.align	2
	.type	halide_mutex_destroy,%function
halide_mutex_destroy:                   @ @halide_mutex_destroy
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	bl	pthread_mutex_destroy(PLT)
	mov	r0, r4
	mov	r1, #0
	mov	r2, #64
	pop	{r4, r10, r11, lr}
	b	memset(PLT)
.Lfunc_end22:
	.size	halide_mutex_destroy, .Lfunc_end22-halide_mutex_destroy
	.cantunwind
	.fnend

	.section	.text.halide_cond_init,"ax",%progbits
	.weak	halide_cond_init
	.align	2
	.type	halide_cond_init,%function
halide_cond_init:                       @ @halide_cond_init
	.fnstart
@ BB#0:
	mov	r1, #0
	b	pthread_cond_init(PLT)
.Lfunc_end23:
	.size	halide_cond_init, .Lfunc_end23-halide_cond_init
	.cantunwind
	.fnend

	.section	.text.halide_cond_destroy,"ax",%progbits
	.weak	halide_cond_destroy
	.align	2
	.type	halide_cond_destroy,%function
halide_cond_destroy:                    @ @halide_cond_destroy
	.fnstart
@ BB#0:
	b	pthread_cond_destroy(PLT)
.Lfunc_end24:
	.size	halide_cond_destroy, .Lfunc_end24-halide_cond_destroy
	.cantunwind
	.fnend

	.section	.text.halide_cond_broadcast,"ax",%progbits
	.weak	halide_cond_broadcast
	.align	2
	.type	halide_cond_broadcast,%function
halide_cond_broadcast:                  @ @halide_cond_broadcast
	.fnstart
@ BB#0:
	b	pthread_cond_broadcast(PLT)
.Lfunc_end25:
	.size	halide_cond_broadcast, .Lfunc_end25-halide_cond_broadcast
	.cantunwind
	.fnend

	.section	.text.halide_cond_wait,"ax",%progbits
	.weak	halide_cond_wait
	.align	2
	.type	halide_cond_wait,%function
halide_cond_wait:                       @ @halide_cond_wait
	.fnstart
@ BB#0:
	b	pthread_cond_wait(PLT)
.Lfunc_end26:
	.size	halide_cond_wait, .Lfunc_end26-halide_cond_wait
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal15default_do_taskEPvPFiS2_iPhEiS3_,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal15default_do_taskEPvPFiS2_iPhEiS3_
	.align	2
	.type	_ZN6Halide7Runtime8Internal15default_do_taskEPvPFiS2_iPhEiS3_,%function
_ZN6Halide7Runtime8Internal15default_do_taskEPvPFiS2_iPhEiS3_: @ @_ZN6Halide7Runtime8Internal15default_do_taskEPvPFiS2_iPhEiS3_
	.fnstart
@ BB#0:
	mov	r12, r1
	mov	r1, r2
	mov	r2, r3
	bx	r12
.Lfunc_end27:
	.size	_ZN6Halide7Runtime8Internal15default_do_taskEPvPFiS2_iPhEiS3_, .Lfunc_end27-_ZN6Halide7Runtime8Internal15default_do_taskEPvPFiS2_iPhEiS3_
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal17clamp_num_threadsEi,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal17clamp_num_threadsEi
	.align	2
	.type	_ZN6Halide7Runtime8Internal17clamp_num_threadsEi,%function
_ZN6Halide7Runtime8Internal17clamp_num_threadsEi: @ @_ZN6Halide7Runtime8Internal17clamp_num_threadsEi
	.fnstart
@ BB#0:
	cmp	r0, #64
	movgt	r0, #64
	bxgt	lr
	cmp	r0, #1
	movwlt	r0, #1
	bx	lr
.Lfunc_end28:
	.size	_ZN6Halide7Runtime8Internal17clamp_num_threadsEi, .Lfunc_end28-_ZN6Halide7Runtime8Internal17clamp_num_threadsEi
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal27default_desired_num_threadsEv,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal27default_desired_num_threadsEv
	.align	2
	.type	_ZN6Halide7Runtime8Internal27default_desired_num_threadsEv,%function
_ZN6Halide7Runtime8Internal27default_desired_num_threadsEv: @ @_ZN6Halide7Runtime8Internal27default_desired_num_threadsEv
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	.setfp	r11, sp
	mov	r11, sp
	ldr	r0, .LCPI29_0
	ldr	r1, .LCPI29_1
.LPC29_0:
	add	r0, pc, r0
	add	r0, r1, r0
	bl	getenv(PLT)
	cmp	r0, #0
	bne	.LBB29_2
@ BB#1:
	ldr	r0, .LCPI29_2
	ldr	r1, .LCPI29_3
.LPC29_1:
	add	r0, pc, r0
	add	r0, r1, r0
	bl	getenv(PLT)
	cmp	r0, #0
	beq	.LBB29_3
.LBB29_2:                               @ %.thread
	pop	{r11, lr}
	b	atoi(PLT)
.LBB29_3:
	pop	{r11, lr}
	b	halide_host_cpu_count(PLT)
	.align	2
@ BB#4:
.LCPI29_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC29_0+8)
.LCPI29_1:
	.long	.L.str.8(GOTOFF)
.LCPI29_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC29_1+8)
.LCPI29_3:
	.long	.L.str.1.9(GOTOFF)
.Lfunc_end29:
	.size	_ZN6Halide7Runtime8Internal27default_desired_num_threadsEv, .Lfunc_end29-_ZN6Halide7Runtime8Internal27default_desired_num_threadsEv
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE
	.align	2
	.type	_ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE,%function
_ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE: @ @_ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#28
	sub	sp, sp, #28
	mov	r4, r0
	ldr	r0, .LCPI30_0
	cmp	r4, #0
	beq	.LBB30_12
@ BB#1:
	ldr	r1, .LCPI30_1
.LPC30_0:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	str	r1, [sp, #24]           @ 4-byte Spill
	ldr	r1, .LCPI30_5
.LPC30_4:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	str	r1, [sp, #20]           @ 4-byte Spill
	ldr	r1, .LCPI30_2
.LPC30_1:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	str	r1, [sp, #16]           @ 4-byte Spill
	ldr	r1, .LCPI30_3
.LPC30_2:
	add	r1, pc, r1
	ldr	r10, [r0, r1]
	ldr	r1, .LCPI30_4
.LPC30_3:
	add	r1, pc, r1
	ldr	r0, [r0, r1]
	add	r0, r0, #80
	str	r0, [sp, #12]           @ 4-byte Spill
	b	.LBB30_3
.LBB30_2:                               @   in Loop: Header=BB30_3 Depth=1
	ldr	r1, [sp, #20]           @ 4-byte Reload
	add	r0, r1, #80
	bl	halide_cond_wait(PLT)
.LBB30_3:                               @ %_ZN6Halide7Runtime8Internal4work7runningEv.exit2.thread.us
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r4, #12]
	ldr	r1, [r4, #16]
	cmp	r0, r1
	blt	.LBB30_5
@ BB#4:                                 @ %_ZN6Halide7Runtime8Internal4work7runningEv.exit.us
                                        @   in Loop: Header=BB30_3 Depth=1
	ldr	r0, [r4, #24]
	cmp	r0, #1
	blt	.LBB30_24
.LBB30_5:                               @ %_ZN6Halide7Runtime8Internal4work7runningEv.exit.thread.us
                                        @   in Loop: Header=BB30_3 Depth=1
	ldr	r0, [sp, #24]           @ 4-byte Reload
	ldr	r9, [r0, #64]
	cmp	r9, #0
	beq	.LBB30_2
@ BB#6:                                 @   in Loop: Header=BB30_3 Depth=1
	ldmib	r9, {r7, r8}
	ldr	r5, [r9, #12]
	ldr	r6, [r9, #20]
	add	r0, r5, #1
	str	r0, [r9, #12]
	ldr	r1, [r9, #16]
	cmp	r0, r1
	bne	.LBB30_8
@ BB#7:                                 @   in Loop: Header=BB30_3 Depth=1
	ldr	r0, [r9]
	ldr	r1, [sp, #16]           @ 4-byte Reload
	str	r0, [r1, #64]
.LBB30_8:                               @   in Loop: Header=BB30_3 Depth=1
	ldr	r0, [r9, #24]
	add	r0, r0, #1
	str	r0, [r9, #24]
	mov	r0, r10
	bl	halide_mutex_unlock(PLT)
	mov	r0, r8
	mov	r1, r7
	mov	r2, r5
	mov	r3, r6
	bl	halide_do_task(PLT)
	mov	r5, r0
	mov	r0, r10
	bl	halide_mutex_lock(PLT)
	cmp	r5, #0
	strne	r5, [r9, #28]
	ldr	r0, [r9, #24]
	sub	r1, r0, #1
	str	r1, [r9, #24]
	ldr	r1, [r9, #12]
	ldr	r2, [r9, #16]
	cmp	r1, r2
	blt	.LBB30_3
@ BB#9:                                 @ %_ZN6Halide7Runtime8Internal4work7runningEv.exit2.us
                                        @   in Loop: Header=BB30_3 Depth=1
	cmp	r9, r4
	beq	.LBB30_3
@ BB#10:                                @ %_ZN6Halide7Runtime8Internal4work7runningEv.exit2.us
                                        @   in Loop: Header=BB30_3 Depth=1
	cmp	r0, #1
	bgt	.LBB30_3
@ BB#11:                                @   in Loop: Header=BB30_3 Depth=1
	ldr	r0, [sp, #12]           @ 4-byte Reload
	bl	halide_cond_broadcast(PLT)
	b	.LBB30_3
.LBB30_12:                              @ %_ZN6Halide7Runtime8Internal4work7runningEv.exit2.thread.preheader
	ldr	r1, .LCPI30_6
.LPC30_5:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	ldrb	r1, [r1, #536]
	cmp	r1, #0
	bne	.LBB30_24
@ BB#13:
	ldr	r1, .LCPI30_7
.LPC30_6:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	str	r1, [sp, #24]           @ 4-byte Spill
	ldr	r1, .LCPI30_11
.LPC30_10:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	str	r1, [sp, #20]           @ 4-byte Spill
	ldr	r1, .LCPI30_13
.LPC30_12:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	str	r1, [sp, #8]            @ 4-byte Spill
	ldr	r1, .LCPI30_12
.LPC30_11:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	str	r1, [sp, #4]            @ 4-byte Spill
	ldr	r1, .LCPI30_14
.LPC30_13:
	add	r1, pc, r1
	ldr	r10, [r0, r1]
	ldr	r1, .LCPI30_8
.LPC30_7:
	add	r1, pc, r1
	ldr	r1, [r0, r1]
	str	r1, [sp, #16]           @ 4-byte Spill
	ldr	r1, .LCPI30_9
.LPC30_8:
	add	r1, pc, r1
	ldr	r6, [r0, r1]
	ldr	r1, .LCPI30_10
.LPC30_9:
	add	r1, pc, r1
	ldr	r0, [r0, r1]
	add	r0, r0, #80
	str	r0, [sp, #12]           @ 4-byte Spill
.LBB30_14:                              @ %_ZN6Halide7Runtime8Internal4work7runningEv.exit.thread
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [sp, #24]           @ 4-byte Reload
	ldr	r9, [r0, #64]
	cmp	r9, #0
	beq	.LBB30_20
@ BB#15:                                @   in Loop: Header=BB30_14 Depth=1
	ldmib	r9, {r7, r8}
	ldr	r5, [r9, #12]
	ldr	r4, [r9, #20]
	add	r0, r5, #1
	str	r0, [r9, #12]
	ldr	r1, [r9, #16]
	cmp	r0, r1
	bne	.LBB30_17
@ BB#16:                                @   in Loop: Header=BB30_14 Depth=1
	ldr	r0, [r9]
	ldr	r1, [sp, #16]           @ 4-byte Reload
	str	r0, [r1, #64]
.LBB30_17:                              @   in Loop: Header=BB30_14 Depth=1
	ldr	r0, [r9, #24]
	add	r0, r0, #1
	str	r0, [r9, #24]
	mov	r0, r6
	bl	halide_mutex_unlock(PLT)
	mov	r0, r8
	mov	r1, r7
	mov	r2, r5
	mov	r3, r4
	bl	halide_do_task(PLT)
	mov	r4, r0
	mov	r0, r6
	bl	halide_mutex_lock(PLT)
	cmp	r4, #0
	strne	r4, [r9, #28]
	ldr	r0, [r9, #24]
	subs	r0, r0, #1
	str	r0, [r9, #24]
	bgt	.LBB30_23
@ BB#18:                                @   in Loop: Header=BB30_14 Depth=1
	ldr	r0, [r9, #12]
	ldr	r1, [r9, #16]
	cmp	r0, r1
	blt	.LBB30_23
@ BB#19:                                @   in Loop: Header=BB30_14 Depth=1
	ldr	r0, [sp, #12]           @ 4-byte Reload
	bl	halide_cond_broadcast(PLT)
	b	.LBB30_23
.LBB30_20:                              @   in Loop: Header=BB30_14 Depth=1
	ldr	r1, [sp, #20]           @ 4-byte Reload
	ldr	r0, [r1, #68]
	ldr	r1, [r1, #72]
	cmp	r0, r1
	ble	.LBB30_22
@ BB#21:                                @   in Loop: Header=BB30_14 Depth=1
	ldr	r4, [sp, #8]            @ 4-byte Reload
	sub	r0, r0, #1
	str	r0, [r4, #68]
	add	r0, r4, #208
	mov	r1, r4
	bl	halide_cond_wait(PLT)
	ldr	r0, [r4, #68]
	add	r0, r0, #1
	str	r0, [r4, #68]
	b	.LBB30_23
.LBB30_22:                              @   in Loop: Header=BB30_14 Depth=1
	ldr	r1, [sp, #4]            @ 4-byte Reload
	add	r0, r1, #144
	bl	halide_cond_wait(PLT)
.LBB30_23:                              @ %_ZN6Halide7Runtime8Internal4work7runningEv.exit2.thread.backedge
                                        @   in Loop: Header=BB30_14 Depth=1
	ldrb	r0, [r10, #536]
	cmp	r0, #0
	beq	.LBB30_14
.LBB30_24:                              @ %.us-lcssa.us
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#25:
.LCPI30_0:
	.long	_ZN6Halide7Runtime8Internal10work_queueE(GOT)
.LCPI30_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_0+8)
.LCPI30_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_1+8)
.LCPI30_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_2+8)
.LCPI30_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_3+8)
.LCPI30_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_4+8)
.LCPI30_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_5+8)
.LCPI30_7:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_6+8)
.LCPI30_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_7+8)
.LCPI30_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_8+8)
.LCPI30_10:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_9+8)
.LCPI30_11:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_10+8)
.LCPI30_12:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_11+8)
.LCPI30_13:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_12+8)
.LCPI30_14:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC30_13+8)
.Lfunc_end30:
	.size	_ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE, .Lfunc_end30-_ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE
	.cantunwind
	.fnend

	.section	.text.halide_do_task,"ax",%progbits
	.weak	halide_do_task
	.align	2
	.type	halide_do_task,%function
halide_do_task:                         @ @halide_do_task
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	ldr	lr, .LCPI31_1
	ldr	r12, .LCPI31_0
.LPC31_0:
	add	lr, pc, lr
	ldr	r12, [r12, lr]
	ldr	r12, [r12]
	pop	{r11, lr}
	bx	r12
	.align	2
@ BB#1:
.LCPI31_0:
	.long	custom_do_task(GOT)
.LCPI31_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC31_0+8)
.Lfunc_end31:
	.size	halide_do_task, .Lfunc_end31-halide_do_task
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal13worker_threadEPv,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal13worker_threadEPv
	.align	2
	.type	_ZN6Halide7Runtime8Internal13worker_threadEPv,%function
_ZN6Halide7Runtime8Internal13worker_threadEPv: @ @_ZN6Halide7Runtime8Internal13worker_threadEPv
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	ldr	r1, .LCPI32_1
	ldr	r0, .LCPI32_0
.LPC32_0:
	add	r1, pc, r1
	ldr	r4, [r0, r1]
	mov	r0, r4
	bl	halide_mutex_lock(PLT)
	mov	r0, #0
	bl	_ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE(PLT)
	mov	r0, r4
	pop	{r4, r10, r11, lr}
	b	halide_mutex_unlock(PLT)
	.align	2
@ BB#1:
.LCPI32_0:
	.long	_ZN6Halide7Runtime8Internal10work_queueE(GOT)
.LCPI32_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC32_0+8)
.Lfunc_end32:
	.size	_ZN6Halide7Runtime8Internal13worker_threadEPv, .Lfunc_end32-_ZN6Halide7Runtime8Internal13worker_threadEPv
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal18default_do_par_forEPvPFiS2_iPhEiiS3_,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal18default_do_par_forEPvPFiS2_iPhEiiS3_
	.align	2
	.type	_ZN6Halide7Runtime8Internal18default_do_par_forEPvPFiS2_iPhEiiS3_,%function
_ZN6Halide7Runtime8Internal18default_do_par_forEPvPFiS2_iPhEiiS3_: @ @_ZN6Halide7Runtime8Internal18default_do_par_forEPvPFiS2_iPhEiiS3_
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#36
	sub	sp, sp, #36
	mov	r7, r0
	ldr	r0, .LCPI33_1
	ldr	r9, .LCPI33_0
	mov	r4, r3
.LPC33_0:
	add	r0, pc, r0
	mov	r5, r2
	str	r1, [sp]                @ 4-byte Spill
	ldr	r6, [r9, r0]
	mov	r0, r6
	bl	halide_mutex_lock(PLT)
	ldrb	r0, [r6, #537]
	cmp	r0, #0
	beq	.LBB33_2
@ BB#1:                                 @ %..preheader_crit_edge
	ldr	r0, .LCPI33_2
.LPC33_1:
	add	r0, pc, r0
	ldr	r0, [r9, r0]
	ldr	r6, [r0, #528]
	ldr	r0, [r0, #532]
	b	.LBB33_5
.LBB33_2:
	ldr	r0, .LCPI33_3
	mov	r8, r7
	mov	r6, #0
.LPC33_2:
	add	r0, pc, r0
	ldr	r7, [r9, r0]
	add	r0, r7, #80
	strb	r6, [r7, #536]
	bl	halide_cond_init(PLT)
	add	r0, r7, #144
	bl	halide_cond_init(PLT)
	add	r0, r7, #208
	bl	halide_cond_init(PLT)
	str	r6, [r7, #64]
	ldr	r0, [r7, #532]
	cmp	r0, #0
	bne	.LBB33_4
@ BB#3:
	ldr	r0, .LCPI33_4
.LPC33_3:
	add	r0, pc, r0
	ldr	r7, [r9, r0]
	bl	_ZN6Halide7Runtime8Internal27default_desired_num_threadsEv(PLT)
	str	r0, [r7, #532]
.LBB33_4:
	ldr	r1, .LCPI33_5
.LPC33_4:
	add	r1, pc, r1
	ldr	r7, [r9, r1]
	bl	_ZN6Halide7Runtime8Internal17clamp_num_threadsEi(PLT)
	mov	r1, #1
	str	r6, [r7, #528]
	str	r0, [r7, #532]
	str	r0, [r7, #68]
	strb	r1, [r7, #537]
	mov	r7, r8
.LBB33_5:                               @ %.preheader
	ldr	r10, [r11, #8]
	sub	r1, r0, #1
	cmp	r6, r1
	bge	.LBB33_8
@ BB#6:
	ldr	r1, .LCPI33_7
	ldr	r0, .LCPI33_6
.LPC33_5:
	add	r1, pc, r1
	ldr	r8, [r9, r1]
	ldr	r6, [r0, r1]
.LBB33_7:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	mov	r0, r6
	mov	r1, #0
	bl	halide_spawn_thread(PLT)
	ldr	r1, [r8, #528]
	add	r2, r8, r1, lsl #2
	add	r1, r1, #1
	str	r1, [r8, #528]
	str	r0, [r2, #272]
	ldr	r0, [r8, #532]
	ldr	r1, [r8, #528]
	sub	r2, r0, #1
	cmp	r1, r2
	blt	.LBB33_7
.LBB33_8:                               @ %._crit_edge
	ldr	r1, .LCPI33_8
	ldr	r2, [sp]                @ 4-byte Reload
.LPC33_6:
	add	r1, pc, r1
	ldr	r6, [r9, r1]
	add	r1, r4, r5
	str	r2, [sp, #8]
	mov	r2, r0
	str	r7, [sp, #12]
	str	r5, [sp, #16]
	str	r1, [sp, #20]
	mov	r1, #0
	str	r10, [sp, #24]
	str	r1, [sp, #32]
	str	r1, [sp, #28]
	ldr	r1, [r6, #64]
	cmp	r1, #0
	moveq	r2, r4
	cmp	r0, r4
	movle	r2, r0
	add	r0, sp, #4
	str	r2, [r6, #72]
	str	r0, [r6, #64]
	add	r0, r6, #144
	str	r1, [sp, #4]
	bl	halide_cond_broadcast(PLT)
	ldr	r0, [r6, #68]
	ldr	r1, [r6, #72]
	cmp	r1, r0
	ble	.LBB33_10
@ BB#9:
	ldr	r0, .LCPI33_9
.LPC33_7:
	add	r0, pc, r0
	ldr	r0, [r9, r0]
	add	r0, r0, #208
	bl	halide_cond_broadcast(PLT)
.LBB33_10:
	add	r0, sp, #4
	bl	_ZN6Halide7Runtime8Internal28worker_thread_already_lockedEPNS1_4workE(PLT)
	ldr	r0, .LCPI33_10
.LPC33_8:
	add	r0, pc, r0
	ldr	r0, [r9, r0]
	bl	halide_mutex_unlock(PLT)
	ldr	r0, [sp, #32]
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#11:
.LCPI33_0:
	.long	_ZN6Halide7Runtime8Internal10work_queueE(GOT)
.LCPI33_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_0+8)
.LCPI33_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_1+8)
.LCPI33_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_2+8)
.LCPI33_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_3+8)
.LCPI33_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_4+8)
.LCPI33_6:
	.long	_ZN6Halide7Runtime8Internal13worker_threadEPv(GOT)
.LCPI33_7:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_5+8)
.LCPI33_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_6+8)
.LCPI33_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_7+8)
.LCPI33_10:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC33_8+8)
.Lfunc_end33:
	.size	_ZN6Halide7Runtime8Internal18default_do_par_forEPvPFiS2_iPhEiiS3_, .Lfunc_end33-_ZN6Halide7Runtime8Internal18default_do_par_forEPvPFiS2_iPhEiiS3_
	.cantunwind
	.fnend

	.section	.text.halide_set_num_threads,"ax",%progbits
	.weak	halide_set_num_threads
	.align	2
	.type	halide_set_num_threads,%function
halide_set_num_threads:                 @ @halide_set_num_threads
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r0
	cmp	r4, #0
	blt	.LBB34_3
@ BB#1:
	ldr	r1, .LCPI34_1
	ldr	r0, .LCPI34_0
.LPC34_0:
	add	r1, pc, r1
	ldr	r0, [r0, r1]
	bl	halide_mutex_lock(PLT)
	cmp	r4, #0
	bne	.LBB34_4
@ BB#2:
	bl	_ZN6Halide7Runtime8Internal27default_desired_num_threadsEv(PLT)
	mov	r4, r0
	b	.LBB34_4
.LBB34_3:                               @ %.thread
	ldr	r0, .LCPI34_2
	ldr	r1, .LCPI34_3
.LPC34_1:
	add	r5, pc, r0
	mov	r0, #0
	add	r1, r1, r5
	bl	halide_error(PLT)
	ldr	r0, .LCPI34_0
	ldr	r0, [r0, r5]
	bl	halide_mutex_lock(PLT)
.LBB34_4:
	ldr	r1, .LCPI34_4
	ldr	r0, .LCPI34_0
.LPC34_2:
	add	r1, pc, r1
	ldr	r5, [r0, r1]
	mov	r0, r4
	ldr	r6, [r5, #532]
	bl	_ZN6Halide7Runtime8Internal17clamp_num_threadsEi(PLT)
	str	r0, [r5, #532]
	mov	r0, r5
	bl	halide_mutex_unlock(PLT)
	mov	r0, r6
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#5:
.LCPI34_0:
	.long	_ZN6Halide7Runtime8Internal10work_queueE(GOT)
.LCPI34_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC34_0+8)
.LCPI34_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC34_1+8)
.LCPI34_3:
	.long	.L.str.2(GOTOFF)
.LCPI34_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC34_2+8)
.Lfunc_end34:
	.size	halide_set_num_threads, .Lfunc_end34-halide_set_num_threads
	.cantunwind
	.fnend

	.section	.text.halide_shutdown_thread_pool,"ax",%progbits
	.weak	halide_shutdown_thread_pool
	.align	2
	.type	halide_shutdown_thread_pool,%function
halide_shutdown_thread_pool:            @ @halide_shutdown_thread_pool
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r11, lr}
	push	{r4, r5, r6, r7, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	ldr	r0, .LCPI35_1
	ldr	r5, .LCPI35_0
.LPC35_0:
	add	r0, pc, r0
	ldr	r0, [r5, r0]
	ldrb	r0, [r0, #537]
	cmp	r0, #0
	beq	.LBB35_5
@ BB#1:
	ldr	r0, .LCPI35_2
.LPC35_1:
	add	r0, pc, r0
	ldr	r4, [r5, r0]
	mov	r0, r4
	bl	halide_mutex_lock(PLT)
	mov	r0, #1
	strb	r0, [r4, #536]
	add	r0, r4, #80
	bl	halide_cond_broadcast(PLT)
	add	r0, r4, #144
	bl	halide_cond_broadcast(PLT)
	add	r0, r4, #208
	bl	halide_cond_broadcast(PLT)
	mov	r0, r4
	bl	halide_mutex_unlock(PLT)
	ldr	r0, [r4, #528]
	cmp	r0, #0
	ble	.LBB35_4
@ BB#2:
	ldr	r0, .LCPI35_3
	add	r4, r4, #272
	mov	r6, #0
.LPC35_2:
	add	r0, pc, r0
	ldr	r7, [r5, r0]
.LBB35_3:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r4], #4
	bl	halide_join_thread(PLT)
	ldr	r0, [r7, #528]
	add	r6, r6, #1
	cmp	r6, r0
	blt	.LBB35_3
.LBB35_4:                               @ %._crit_edge
	ldr	r0, .LCPI35_4
.LPC35_3:
	add	r0, pc, r0
	ldr	r4, [r5, r0]
	mov	r0, r4
	bl	halide_mutex_destroy(PLT)
	add	r0, r4, #80
	bl	halide_cond_destroy(PLT)
	add	r0, r4, #144
	bl	halide_cond_destroy(PLT)
	add	r0, r4, #208
	bl	halide_cond_destroy(PLT)
	mov	r0, #0
	strb	r0, [r4, #537]
.LBB35_5:
	pop	{r4, r5, r6, r7, r11, pc}
	.align	2
@ BB#6:
.LCPI35_0:
	.long	_ZN6Halide7Runtime8Internal10work_queueE(GOT)
.LCPI35_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC35_0+8)
.LCPI35_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC35_1+8)
.LCPI35_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC35_2+8)
.LCPI35_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC35_3+8)
.Lfunc_end35:
	.size	halide_shutdown_thread_pool, .Lfunc_end35-halide_shutdown_thread_pool
	.cantunwind
	.fnend

	.section	.text.halide_thread_pool_cleanup,"ax",%progbits
	.weak	halide_thread_pool_cleanup
	.align	2
	.type	halide_thread_pool_cleanup,%function
halide_thread_pool_cleanup:             @ @halide_thread_pool_cleanup
	.fnstart
@ BB#0:
	b	halide_shutdown_thread_pool(PLT)
.Lfunc_end36:
	.size	halide_thread_pool_cleanup, .Lfunc_end36-halide_thread_pool_cleanup
	.cantunwind
	.fnend

	.section	.text.halide_set_custom_do_task,"ax",%progbits
	.weak	halide_set_custom_do_task
	.align	2
	.type	halide_set_custom_do_task,%function
halide_set_custom_do_task:              @ @halide_set_custom_do_task
	.fnstart
@ BB#0:
	ldr	r2, .LCPI37_1
	ldr	r1, .LCPI37_0
.LPC37_0:
	add	r2, pc, r2
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	str	r0, [r2]
	mov	r0, r1
	bx	lr
	.align	2
@ BB#1:
.LCPI37_0:
	.long	custom_do_task(GOT)
.LCPI37_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC37_0+8)
.Lfunc_end37:
	.size	halide_set_custom_do_task, .Lfunc_end37-halide_set_custom_do_task
	.cantunwind
	.fnend

	.section	.text.halide_set_custom_do_par_for,"ax",%progbits
	.weak	halide_set_custom_do_par_for
	.align	2
	.type	halide_set_custom_do_par_for,%function
halide_set_custom_do_par_for:           @ @halide_set_custom_do_par_for
	.fnstart
@ BB#0:
	ldr	r2, .LCPI38_1
	ldr	r1, .LCPI38_0
.LPC38_0:
	add	r2, pc, r2
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	str	r0, [r2]
	mov	r0, r1
	bx	lr
	.align	2
@ BB#1:
.LCPI38_0:
	.long	custom_do_par_for(GOT)
.LCPI38_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC38_0+8)
.Lfunc_end38:
	.size	halide_set_custom_do_par_for, .Lfunc_end38-halide_set_custom_do_par_for
	.cantunwind
	.fnend

	.section	.text.halide_do_par_for,"ax",%progbits
	.weak	halide_do_par_for
	.align	2
	.type	halide_do_par_for,%function
halide_do_par_for:                      @ @halide_do_par_for
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	ldr	lr, .LCPI39_1
	ldr	r12, .LCPI39_0
.LPC39_0:
	add	lr, pc, lr
	ldr	r12, [r12, lr]
	ldr	r12, [r12]
	pop	{r11, lr}
	bx	r12
	.align	2
@ BB#1:
.LCPI39_0:
	.long	custom_do_par_for(GOT)
.LCPI39_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC39_0+8)
.Lfunc_end39:
	.size	halide_do_par_for, .Lfunc_end39-halide_do_par_for
	.cantunwind
	.fnend

	.section	.text.halide_get_symbol,"ax",%progbits
	.weak	halide_get_symbol
	.align	2
	.type	halide_get_symbol,%function
halide_get_symbol:                      @ @halide_get_symbol
	.fnstart
@ BB#0:
	mov	r1, r0
	mov	r0, #0
	b	dlsym(PLT)
.Lfunc_end40:
	.size	halide_get_symbol, .Lfunc_end40-halide_get_symbol
	.cantunwind
	.fnend

	.section	.text.halide_load_library,"ax",%progbits
	.weak	halide_load_library
	.align	2
	.type	halide_load_library,%function
halide_load_library:                    @ @halide_load_library
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r1, #1
	bl	dlopen(PLT)
	mov	r4, r0
	cmp	r4, #0
	bne	.LBB41_2
@ BB#1:
	bl	dlerror(PLT)
.LBB41_2:
	mov	r0, r4
	pop	{r4, r10, r11, pc}
.Lfunc_end41:
	.size	halide_load_library, .Lfunc_end41-halide_load_library
	.cantunwind
	.fnend

	.section	.text.halide_get_library_symbol,"ax",%progbits
	.weak	halide_get_library_symbol
	.align	2
	.type	halide_get_library_symbol,%function
halide_get_library_symbol:              @ @halide_get_library_symbol
	.fnstart
@ BB#0:
	b	dlsym(PLT)
.Lfunc_end42:
	.size	halide_get_library_symbol, .Lfunc_end42-halide_get_library_symbol
	.cantunwind
	.fnend

	.section	.text.halide_profiler_get_state,"ax",%progbits
	.weak	halide_profiler_get_state
	.align	2
	.type	halide_profiler_get_state,%function
halide_profiler_get_state:              @ @halide_profiler_get_state
	.fnstart
@ BB#0:
	ldr	r0, .LCPI43_0
	ldr	r1, .LCPI43_1
.LPC43_0:
	add	r0, pc, r0
	add	r0, r1, r0
	bx	lr
	.align	2
@ BB#1:
.LCPI43_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC43_0+8)
.LCPI43_1:
	.long	_ZZ25halide_profiler_get_stateE1s(GOTOFF)
.Lfunc_end43:
	.size	halide_profiler_get_state, .Lfunc_end43-halide_profiler_get_state
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal23find_or_create_pipelineEPKciPKy,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal23find_or_create_pipelineEPKciPKy
	.align	2
	.type	_ZN6Halide7Runtime8Internal23find_or_create_pipelineEPKciPKy,%function
_ZN6Halide7Runtime8Internal23find_or_create_pipelineEPKciPKy: @ @_ZN6Halide7Runtime8Internal23find_or_create_pipelineEPKciPKy
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	.vsave	{d8, d9}
	vpush	{d8, d9}
	mov	r5, r2
	mov	r9, r1
	mov	r4, r0
	bl	halide_profiler_get_state(PLT)
	mov	r8, r0
	ldr	r6, [r8, #80]
	b	.LBB44_2
.LBB44_1:                               @   in Loop: Header=BB44_2 Depth=1
	ldr	r6, [r6, #56]
.LBB44_2:                               @ =>This Inner Loop Header: Depth=1
	cmp	r6, #0
	beq	.LBB44_5
@ BB#3:                                 @ %.lr.ph8
                                        @   in Loop: Header=BB44_2 Depth=1
	ldr	r0, [r6, #48]
	cmp	r0, r4
	bne	.LBB44_1
@ BB#4:                                 @   in Loop: Header=BB44_2 Depth=1
	ldr	r0, [r6, #60]
	cmp	r0, r9
	bne	.LBB44_1
	b	.LBB44_12
.LBB44_5:                               @ %.critedge
	mov	r0, #80
	bl	malloc(PLT)
	mov	r7, r0
	mov	r6, #0
	cmp	r7, #0
	beq	.LBB44_12
@ BB#6:
	ldr	r0, [r8, #80]
	mov	r6, #0
	vmov.i32	q4, #0x0
	str	r0, [r7, #56]
	str	r4, [r7, #48]
	ldr	r0, [r8, #68]
	str	r0, [r7, #64]
	add	r0, r7, #32
	str	r9, [r7, #60]
	str	r6, [r7, #68]
	str	r6, [r7, #72]
	str	r6, [r7, #76]
	vst1.64	{d8, d9}, [r0]
	mov	r0, r7
	vst1.64	{d8, d9}, [r0]!
	vst1.64	{d8, d9}, [r0]
	lsl	r0, r9, #6
	bl	malloc(PLT)
	str	r0, [r7, #52]
	cmp	r0, #0
	beq	.LBB44_11
@ BB#7:                                 @ %.preheader
	cmp	r9, #0
	ble	.LBB44_10
@ BB#8:
	mov	r1, #0
	mov	r2, r9
.LBB44_9:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	str	r1, [r0, #4]
	subs	r2, r2, #1
	str	r1, [r0]
	ldr	r3, [r5], #8
	str	r3, [r0, #56]
	add	r3, r0, #40
	str	r1, [r0, #60]
	vst1.64	{d8, d9}, [r3]
	add	r3, r0, #24
	vst1.64	{d8, d9}, [r3]
	add	r3, r0, #8
	add	r0, r0, #64
	vst1.64	{d8, d9}, [r3]
	bne	.LBB44_9
.LBB44_10:                              @ %._crit_edge
	ldr	r0, [r8, #68]
	mov	r6, r7
	add	r0, r0, r9
	str	r0, [r8, #68]
	str	r7, [r8, #80]
	b	.LBB44_12
.LBB44_11:
	mov	r0, r7
	bl	free(PLT)
.LBB44_12:                              @ %.loopexit
	mov	r0, r6
	vpop	{d8, d9}
	pop	{r4, r5, r6, r7, r8, r9, r11, pc}
.Lfunc_end44:
	.size	_ZN6Halide7Runtime8Internal23find_or_create_pipelineEPKciPKy, .Lfunc_end44-_ZN6Halide7Runtime8Internal23find_or_create_pipelineEPKciPKy
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal9bill_funcEP21halide_profiler_stateiyi,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal9bill_funcEP21halide_profiler_stateiyi
	.align	2
	.type	_ZN6Halide7Runtime8Internal9bill_funcEP21halide_profiler_stateiyi,%function
_ZN6Halide7Runtime8Internal9bill_funcEP21halide_profiler_stateiyi: @ @_ZN6Halide7Runtime8Internal9bill_funcEP21halide_profiler_stateiyi
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r11, lr}
	push	{r4, r5, r6, r7, r11, lr}
	ldr	r4, [r0, #80]
	cmp	r4, #0
	beq	.LBB45_5
@ BB#1:
	ldr	lr, [sp, #24]
	mov	r6, #0
	mov	r5, r4
.LBB45_2:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	mov	r12, r5
	ldr	r5, [r12, #64]
	cmp	r5, r1
	bgt	.LBB45_4
@ BB#3:                                 @   in Loop: Header=BB45_2 Depth=1
	ldr	r7, [r12, #60]
	add	r7, r7, r5
	cmp	r7, r1
	bgt	.LBB45_6
.LBB45_4:                               @   in Loop: Header=BB45_2 Depth=1
	ldr	r5, [r12, #56]
	mov	r6, r12
	cmp	r5, #0
	bne	.LBB45_2
.LBB45_5:                               @ %.loopexit
	pop	{r4, r5, r6, r7, r11, pc}
.LBB45_6:
	cmp	r6, #0
	beq	.LBB45_8
@ BB#7:
	ldr	r7, [r12, #56]
	str	r7, [r6, #56]
	str	r4, [r12, #56]
	str	r12, [r0, #80]
.LBB45_8:                               @ %.critedge
	ldr	r0, [r12, #52]
	asr	r7, lr, #31
	vldr	s3, .LCPI45_0
	add	r0, r0, r1, lsl #6
	vldr	s2, .LCPI45_1
	vmov	s0, lr
	ldr	r1, [r0, -r5, lsl #6]!
	vmov.32	d0[1], r7
	ldr	r7, [r0, #4]
	adds	r4, r1, r2
	adc	r5, r7, r3
	strd	r4, r5, [r0]
	add	r0, r0, #40
	vld1.64	{d16, d17}, [r0]
	vadd.i64	q8, q8, q0
	vst1.64	{d16, d17}, [r0]
	ldm	r12, {r0, r1}
	adds	r0, r0, r2
	str	r0, [r12]
	adc	r0, r1, r3
	str	r0, [r12, #4]
	ldr	r0, [r12, #72]
	add	r0, r0, #1
	str	r0, [r12, #72]
	add	r0, r12, #32
	vld1.64	{d16, d17}, [r0]
	vadd.i64	q8, q8, q0
	vst1.64	{d16, d17}, [r0]
	pop	{r4, r5, r6, r7, r11, pc}
	.align	2
@ BB#9:
.LCPI45_0:
	.long	0                       @ float 0
.LCPI45_1:
	.long	1                       @ float 1.40129846E-45
.Lfunc_end45:
	.size	_ZN6Halide7Runtime8Internal9bill_funcEP21halide_profiler_stateiyi, .Lfunc_end45-_ZN6Halide7Runtime8Internal9bill_funcEP21halide_profiler_stateiyi
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal24sampling_profiler_threadEPv,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal24sampling_profiler_threadEPv
	.align	2
	.type	_ZN6Halide7Runtime8Internal24sampling_profiler_threadEPv,%function
_ZN6Halide7Runtime8Internal24sampling_profiler_threadEPv: @ @_ZN6Halide7Runtime8Internal24sampling_profiler_threadEPv
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#12
	sub	sp, sp, #12
	bl	halide_profiler_get_state(PLT)
	mov	r4, r0
	bl	halide_mutex_lock(PLT)
	ldr	r0, [r4, #72]
	cmn	r0, #2
	beq	.LBB46_11
@ BB#1:                                 @ %.lr.ph
	add	r8, sp, #8
	add	r9, sp, #4
.LBB46_2:                               @ =>This Loop Header: Depth=1
                                        @     Child Loop BB46_4 Depth 2
	mov	r0, #0
	bl	halide_current_time_ns(PLT)
	mov	r10, r0
	mov	r5, r1
	b	.LBB46_4
.LBB46_3:                               @ %.thread
                                        @   in Loop: Header=BB46_4 Depth=2
	mov	r0, r4
	ldr	r5, [r4, #64]
	bl	halide_mutex_unlock(PLT)
	mov	r0, #0
	mov	r1, r5
	bl	halide_sleep_ms(PLT)
	mov	r0, r4
	bl	halide_mutex_lock(PLT)
	mov	r10, r6
	mov	r5, r7
.LBB46_4:                               @   Parent Loop BB46_2 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldr	r2, [r4, #84]
	cmp	r2, #0
	beq	.LBB46_6
@ BB#5:                                 @   in Loop: Header=BB46_4 Depth=2
	mov	r0, r8
	mov	r1, r9
	blx	r2
	b	.LBB46_7
.LBB46_6:                               @   in Loop: Header=BB46_4 Depth=2
	ldr	r0, [r4, #72]
	str	r0, [sp, #8]
	ldr	r0, [r4, #76]
	str	r0, [sp, #4]
.LBB46_7:                               @   in Loop: Header=BB46_4 Depth=2
	mov	r0, #0
	bl	halide_current_time_ns(PLT)
	mov	r7, r1
	ldr	r1, [sp, #8]
	mov	r6, r0
	cmn	r1, #2
	beq	.LBB46_10
@ BB#8:                                 @   in Loop: Header=BB46_4 Depth=2
	cmp	r1, #0
	blt	.LBB46_3
@ BB#9:                                 @   in Loop: Header=BB46_4 Depth=2
	ldr	r0, [sp, #4]
	subs	r2, r6, r10
	sbc	r3, r7, r5
	str	r0, [sp]
	mov	r0, r4
	bl	_ZN6Halide7Runtime8Internal9bill_funcEP21halide_profiler_stateiyi(PLT)
	b	.LBB46_3
.LBB46_10:                              @   in Loop: Header=BB46_2 Depth=1
	ldr	r0, [r4, #72]
	cmn	r0, #2
	bne	.LBB46_2
.LBB46_11:                              @ %._crit_edge
	mov	r0, #0
	strb	r0, [r4, #88]
	mov	r0, r4
	bl	halide_mutex_unlock(PLT)
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.Lfunc_end46:
	.size	_ZN6Halide7Runtime8Internal24sampling_profiler_threadEPv, .Lfunc_end46-_ZN6Halide7Runtime8Internal24sampling_profiler_threadEPv
	.cantunwind
	.fnend

	.section	.text.halide_profiler_get_pipeline_state,"ax",%progbits
	.weak	halide_profiler_get_pipeline_state
	.align	2
	.type	halide_profiler_get_pipeline_state,%function
halide_profiler_get_pipeline_state:     @ @halide_profiler_get_pipeline_state
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r6, r0
	bl	halide_profiler_get_state(PLT)
	mov	r4, r0
	bl	halide_mutex_lock(PLT)
	ldr	r0, [r4, #80]
	mov	r5, #0
	b	.LBB47_2
.LBB47_1:                               @   in Loop: Header=BB47_2 Depth=1
	ldr	r0, [r0, #56]
.LBB47_2:                               @ =>This Inner Loop Header: Depth=1
	cmp	r0, #0
	beq	.LBB47_5
@ BB#3:                                 @ %.lr.ph
                                        @   in Loop: Header=BB47_2 Depth=1
	ldr	r1, [r0, #48]
	cmp	r1, r6
	bne	.LBB47_1
@ BB#4:
	mov	r5, r0
.LBB47_5:                               @ %._crit_edge
	mov	r0, r4
	bl	halide_mutex_unlock(PLT)
	mov	r0, r5
	pop	{r4, r5, r6, r10, r11, pc}
.Lfunc_end47:
	.size	halide_profiler_get_pipeline_state, .Lfunc_end47-halide_profiler_get_pipeline_state
	.cantunwind
	.fnend

	.section	.text.halide_profiler_pipeline_start,"ax",%progbits
	.weak	halide_profiler_pipeline_start
	.align	2
	.type	halide_profiler_pipeline_start,%function
halide_profiler_pipeline_start:         @ @halide_profiler_pipeline_start
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	mov	r6, r3
	mov	r7, r2
	mov	r5, r1
	mov	r8, r0
	bl	halide_profiler_get_state(PLT)
	mov	r4, r0
	bl	halide_mutex_lock(PLT)
	ldrb	r0, [r4, #88]
	cmp	r0, #0
	bne	.LBB48_2
@ BB#1:
	mov	r0, r8
	bl	halide_start_clock(PLT)
	ldr	r1, .LCPI48_1
	ldr	r0, .LCPI48_0
.LPC48_0:
	add	r1, pc, r1
	ldr	r0, [r0, r1]
	mov	r1, #0
	bl	halide_spawn_thread(PLT)
	mov	r0, #1
	strb	r0, [r4, #88]
.LBB48_2:
	mov	r0, r5
	mov	r1, r7
	mov	r2, r6
	bl	_ZN6Halide7Runtime8Internal23find_or_create_pipelineEPKciPKy(PLT)
	cmp	r0, #0
	beq	.LBB48_4
@ BB#3:
	ldr	r1, [r0, #68]
	add	r1, r1, #1
	str	r1, [r0, #68]
	ldr	r5, [r0, #64]
	b	.LBB48_5
.LBB48_4:
	mov	r0, r8
	bl	halide_error_out_of_memory(PLT)
	mov	r5, r0
.LBB48_5:
	mov	r0, r4
	bl	halide_mutex_unlock(PLT)
	mov	r0, r5
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
	.align	2
@ BB#6:
.LCPI48_0:
	.long	_ZN6Halide7Runtime8Internal24sampling_profiler_threadEPv(GOT)
.LCPI48_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC48_0+8)
.Lfunc_end48:
	.size	halide_profiler_pipeline_start, .Lfunc_end48-halide_profiler_pipeline_start
	.cantunwind
	.fnend

	.section	.text.halide_profiler_stack_peak_update,"ax",%progbits
	.weak	halide_profiler_stack_peak_update
	.align	2
	.type	halide_profiler_stack_peak_update,%function
halide_profiler_stack_peak_update:      @ @halide_profiler_stack_peak_update
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#12
	sub	sp, sp, #12
	mov	r10, r1
	cmp	r10, #0
	bne	.LBB49_2
@ BB#1:
	ldr	r1, .LCPI49_0
	mov	r4, r2
	ldr	r3, .LCPI49_1
.LPC49_0:
	add	r1, pc, r1
	add	r1, r3, r1
	bl	halide_print(PLT)
	bl	abort(PLT)
	mov	r2, r4
.LBB49_2:                               @ %.preheader
	ldr	r1, [r10, #60]
	cmp	r1, #1
	blt	.LBB49_13
@ BB#3:                                 @ %.lr.ph
	mov	r12, #0
.LBB49_4:                               @ =>This Loop Header: Depth=1
                                        @     Child Loop BB49_6 Depth 2
                                        @       Child Loop BB49_8 Depth 3
	mov	r3, r2
	ldr	r4, [r3, r12, lsl #3]!
	ldr	r5, [r3, #4]
	strd	r4, r5, [sp]            @ 8-byte Spill
	orrs	r3, r4, r5
	beq	.LBB49_12
@ BB#5:                                 @   in Loop: Header=BB49_4 Depth=1
	ldr	r1, [r10, #52]
	add	r4, r1, r12, lsl #6
	ldr	lr, [r4, #32]!
	ldr	r6, [r4, #4]
.LBB49_6:                               @   Parent Loop BB49_4 Depth=1
                                        @ =>  This Loop Header: Depth=2
                                        @       Child Loop BB49_8 Depth 3
	ldrd	r0, r1, [sp]            @ 8-byte Reload
	mov	r7, #0
	mov	r3, #0
	cmp	lr, r0
	movwhs	r7, #1
	cmp	r6, r1
	movwhs	r3, #1
	strd	r0, r1, [sp]            @ 8-byte Spill
	moveq	r3, r7
	cmp	r3, #0
	bne	.LBB49_11
@ BB#7:                                 @   in Loop: Header=BB49_6 Depth=2
	dmb	ish
.LBB49_8:                               @ %cmpxchg.start
                                        @   Parent Loop BB49_4 Depth=1
                                        @     Parent Loop BB49_6 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	ldrexd	r8, r9, [r4]
	eor	r7, r8, lr
	eor	r5, r9, r6
	orrs	r7, r7, r5
	bne	.LBB49_10
@ BB#9:                                 @ %cmpxchg.trystore
                                        @   in Loop: Header=BB49_8 Depth=3
	ldrd	r0, r1, [sp]            @ 8-byte Reload
	strexd	r5, r0, r1, [r4]
	cmp	r5, #0
	bne	.LBB49_8
.LBB49_10:                              @ %cmpxchg.failure
                                        @   in Loop: Header=BB49_6 Depth=2
	mov	lr, r8
	mov	r6, r9
	dmb	ish
	cmp	r7, #0
	bne	.LBB49_6
.LBB49_11:                              @ %_ZN12_GLOBAL__N_125sync_compare_max_and_swapIyEEvPT_S1_.exit.loopexit
                                        @   in Loop: Header=BB49_4 Depth=1
	ldr	r1, [r10, #60]
.LBB49_12:                              @ %_ZN12_GLOBAL__N_125sync_compare_max_and_swapIyEEvPT_S1_.exit
                                        @   in Loop: Header=BB49_4 Depth=1
	add	r12, r12, #1
	cmp	r12, r1
	blt	.LBB49_4
.LBB49_13:                              @ %._crit_edge
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#14:
.LCPI49_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC49_0+8)
.LCPI49_1:
	.long	.L.str.13(GOTOFF)
.Lfunc_end49:
	.size	halide_profiler_stack_peak_update, .Lfunc_end49-halide_profiler_stack_peak_update
	.cantunwind
	.fnend

	.section	.text.halide_profiler_memory_allocate,"ax",%progbits
	.weak	halide_profiler_memory_allocate
	.align	2
	.type	halide_profiler_memory_allocate,%function
halide_profiler_memory_allocate:        @ @halide_profiler_memory_allocate
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	ldr	r7, [r11, #12]
	mov	r4, r2
	ldr	r8, [r11, #8]
	mov	r6, r0
	mov	r10, r1
	orrs	r0, r8, r7
	beq	.LBB50_31
@ BB#1:
	cmp	r10, #0
	bne	.LBB50_3
@ BB#2:
	ldr	r0, .LCPI50_0
	ldr	r1, .LCPI50_1
.LPC50_0:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r6
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB50_3:
	cmp	r4, #0
	bge	.LBB50_5
@ BB#4:
	ldr	r0, .LCPI50_2
	ldr	r1, .LCPI50_3
.LPC50_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r6
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB50_5:
	ldr	r0, [r10, #60]
	cmp	r0, r4
	bgt	.LBB50_7
@ BB#6:
	ldr	r0, .LCPI50_4
	ldr	r1, .LCPI50_5
.LPC50_2:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r6
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB50_7:
	ldr	lr, [r10, #52]
	mov	r0, r4
	add	r1, r10, #76
	dmb	ish
.LBB50_8:                               @ %atomicrmw.start
                                        @ =>This Inner Loop Header: Depth=1
	ldrex	r2, [r1]
	add	r2, r2, #1
	strex	r3, r2, [r1]
	cmp	r3, #0
	bne	.LBB50_8
@ BB#9:                                 @ %atomicrmw.end
	dmb	ish
	add	r1, r10, #24
.LBB50_10:                              @ %atomicrmw.start2
                                        @ =>This Inner Loop Header: Depth=1
	ldrexd	r2, r3, [r1]
	adds	r4, r2, r8
	adc	r5, r3, r7
	strexd	r2, r4, r5, [r1]
	cmp	r2, #0
	bne	.LBB50_10
@ BB#11:                                @ %atomicrmw.end1
	dmb	ish
	add	r1, r10, #8
.LBB50_12:                              @ %atomicrmw.start8
                                        @ =>This Inner Loop Header: Depth=1
	ldrexd	r4, r5, [r1]
	adds	r2, r4, r8
	adc	r3, r5, r7
	strexd	r6, r2, r3, [r1]
	cmp	r6, #0
	bne	.LBB50_12
@ BB#13:                                @ %atomicrmw.end7
	dmb	ish
	adds	r2, r4, r8
	ldr	r1, [r10, #16]!
	mov	r12, r8
	adc	r3, r5, r7
	ldr	r6, [r10, #4]
.LBB50_14:                              @ =>This Loop Header: Depth=1
                                        @     Child Loop BB50_16 Depth 2
	cmp	r1, r2
	mov	r5, #0
	movwhs	r5, #1
	cmp	r6, r3
	mov	r4, #0
	movwhs	r4, #1
	moveq	r4, r5
	cmp	r4, #0
	bne	.LBB50_19
@ BB#15:                                @   in Loop: Header=BB50_14 Depth=1
	dmb	ish
.LBB50_16:                              @ %cmpxchg.start
                                        @   Parent Loop BB50_14 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrexd	r8, r9, [r10]
	eor	r5, r8, r1
	eor	r4, r9, r6
	orrs	r5, r5, r4
	bne	.LBB50_18
@ BB#17:                                @ %cmpxchg.trystore
                                        @   in Loop: Header=BB50_16 Depth=2
	strexd	r4, r2, r3, [r10]
	cmp	r4, #0
	bne	.LBB50_16
.LBB50_18:                              @ %cmpxchg.failure
                                        @   in Loop: Header=BB50_14 Depth=1
	mov	r1, r8
	mov	r6, r9
	dmb	ish
	cmp	r5, #0
	bne	.LBB50_14
.LBB50_19:                              @ %_ZN12_GLOBAL__N_125sync_compare_max_and_swapIyEEvPT_S1_.exit
	add	r0, lr, r0, lsl #6
	dmb	ish
	add	r1, r0, #60
.LBB50_20:                              @ %atomicrmw.start28
                                        @ =>This Inner Loop Header: Depth=1
	ldrex	r2, [r1]
	add	r2, r2, #1
	strex	r3, r2, [r1]
	cmp	r3, #0
	bne	.LBB50_20
@ BB#21:                                @ %atomicrmw.end27
	add	r1, r0, #24
	dmb	ish
.LBB50_22:                              @ %atomicrmw.start32
                                        @ =>This Inner Loop Header: Depth=1
	ldrexd	r2, r3, [r1]
	adds	r4, r2, r12
	adc	r5, r3, r7
	strexd	r2, r4, r5, [r1]
	cmp	r2, #0
	bne	.LBB50_22
@ BB#23:                                @ %atomicrmw.end31
	add	r1, r0, #8
	dmb	ish
.LBB50_24:                              @ %atomicrmw.start44
                                        @ =>This Inner Loop Header: Depth=1
	ldrexd	r4, r5, [r1]
	adds	r2, r4, r12
	adc	r3, r5, r7
	strexd	r6, r2, r3, [r1]
	cmp	r6, #0
	bne	.LBB50_24
@ BB#25:                                @ %atomicrmw.end43
	dmb	ish
	adds	r8, r4, r12
	ldr	r1, [r0, #16]!
	adc	r9, r5, r7
	ldr	r6, [r0, #4]
.LBB50_26:                              @ =>This Loop Header: Depth=1
                                        @     Child Loop BB50_28 Depth 2
	cmp	r1, r8
	mov	r7, #0
	movwhs	r7, #1
	cmp	r6, r9
	mov	r5, #0
	movwhs	r5, #1
	moveq	r5, r7
	cmp	r5, #0
	bne	.LBB50_31
@ BB#27:                                @   in Loop: Header=BB50_26 Depth=1
	dmb	ish
.LBB50_28:                              @ %cmpxchg.start59
                                        @   Parent Loop BB50_26 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrexd	r4, r5, [r0]
	eor	r7, r4, r1
	eor	r2, r5, r6
	orrs	r7, r7, r2
	bne	.LBB50_30
@ BB#29:                                @ %cmpxchg.trystore58
                                        @   in Loop: Header=BB50_28 Depth=2
	strexd	r2, r8, r9, [r0]
	cmp	r2, #0
	bne	.LBB50_28
.LBB50_30:                              @ %cmpxchg.failure56
                                        @   in Loop: Header=BB50_26 Depth=1
	mov	r1, r4
	mov	r6, r5
	dmb	ish
	cmp	r7, #0
	bne	.LBB50_26
.LBB50_31:                              @ %_ZN12_GLOBAL__N_125sync_compare_max_and_swapIyEEvPT_S1_.exit3
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#32:
.LCPI50_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC50_0+8)
.LCPI50_1:
	.long	.L.str.1.14(GOTOFF)
.LCPI50_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC50_1+8)
.LCPI50_3:
	.long	.L.str.2.15(GOTOFF)
.LCPI50_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC50_2+8)
.LCPI50_5:
	.long	.L.str.3(GOTOFF)
.Lfunc_end50:
	.size	halide_profiler_memory_allocate, .Lfunc_end50-halide_profiler_memory_allocate
	.cantunwind
	.fnend

	.section	.text.halide_profiler_memory_free,"ax",%progbits
	.weak	halide_profiler_memory_free
	.align	2
	.type	halide_profiler_memory_free,%function
halide_profiler_memory_free:            @ @halide_profiler_memory_free
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	ldr	r7, [r11, #12]
	mov	r9, r2
	ldr	r6, [r11, #8]
	mov	r8, r0
	mov	r5, r1
	orrs	r0, r6, r7
	beq	.LBB51_12
@ BB#1:
	cmp	r5, #0
	bne	.LBB51_3
@ BB#2:
	ldr	r0, .LCPI51_0
	ldr	r1, .LCPI51_1
.LPC51_0:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r8
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB51_3:
	cmp	r9, #0
	bge	.LBB51_5
@ BB#4:
	ldr	r0, .LCPI51_2
	ldr	r1, .LCPI51_3
.LPC51_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r8
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB51_5:
	ldr	r0, [r5, #60]
	cmp	r0, r9
	bgt	.LBB51_7
@ BB#6:
	ldr	r0, .LCPI51_4
	ldr	r1, .LCPI51_5
.LPC51_2:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r8
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB51_7:
	ldr	r0, [r5, #52]
	add	r1, r5, #8
	dmb	ish
.LBB51_8:                               @ %atomicrmw.start
                                        @ =>This Inner Loop Header: Depth=1
	ldrexd	r2, r3, [r1]
	subs	r4, r2, r6
	sbc	r5, r3, r7
	strexd	r2, r4, r5, [r1]
	cmp	r2, #0
	bne	.LBB51_8
@ BB#9:                                 @ %atomicrmw.end
	add	r0, r0, r9, lsl #6
	dmb	ish
	add	r0, r0, #8
.LBB51_10:                              @ %atomicrmw.start4
                                        @ =>This Inner Loop Header: Depth=1
	ldrexd	r2, r3, [r0]
	subs	r4, r2, r6
	sbc	r5, r3, r7
	strexd	r1, r4, r5, [r0]
	cmp	r1, #0
	bne	.LBB51_10
@ BB#11:                                @ %atomicrmw.end3
	dmb	ish
.LBB51_12:
	pop	{r4, r5, r6, r7, r8, r9, r11, pc}
	.align	2
@ BB#13:
.LCPI51_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC51_0+8)
.LCPI51_1:
	.long	.L.str.4(GOTOFF)
.LCPI51_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC51_1+8)
.LCPI51_3:
	.long	.L.str.5(GOTOFF)
.LCPI51_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC51_2+8)
.LCPI51_5:
	.long	.L.str.6(GOTOFF)
.Lfunc_end51:
	.size	halide_profiler_memory_free, .Lfunc_end51-halide_profiler_memory_free
	.cantunwind
	.fnend

	.section	.text.halide_profiler_report_unlocked,"ax",%progbits
	.weak	halide_profiler_report_unlocked
	.align	3
	.type	halide_profiler_report_unlocked,%function
halide_profiler_report_unlocked:        @ @halide_profiler_report_unlocked
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	.vsave	{d8, d9, d10}
	vpush	{d8, d9, d10}
	.pad	#152
	sub	sp, sp, #152
	.pad	#1024
	sub	sp, sp, #1024
	mov	r9, #0
	str	r0, [sp, #128]          @ 4-byte Spill
	strb	r9, [sp, #1171]
	ldr	r10, [r1, #80]
	cmp	r10, #0
	beq	.LBB52_47
@ BB#1:
	movw	r0, #1023
	add	r8, sp, #148
	add	r6, r8, r0
	ldr	r0, .LCPI52_1
	ldr	r3, .LCPI52_2
.LPC52_0:
	add	r0, pc, r0
	ldr	r2, .LCPI52_22
	add	r1, r3, r0
	vldr	d9, .LCPI52_42
	str	r1, [sp, #52]           @ 4-byte Spill
	ldr	r1, .LCPI52_3
	vldr	s16, .LCPI52_43
	add	r1, r1, r0
	str	r1, [sp, #48]           @ 4-byte Spill
	ldr	r1, .LCPI52_4
	add	r1, r1, r0
	str	r1, [sp, #44]           @ 4-byte Spill
	ldr	r1, .LCPI52_5
	add	r1, r1, r0
	str	r1, [sp, #40]           @ 4-byte Spill
	ldr	r1, .LCPI52_6
	add	r1, r1, r0
	str	r1, [sp, #36]           @ 4-byte Spill
	ldr	r1, .LCPI52_7
	add	r1, r1, r0
	str	r1, [sp, #32]           @ 4-byte Spill
	ldr	r1, .LCPI52_8
	add	r0, r1, r0
	ldr	r1, .LCPI52_13
	str	r0, [sp, #28]           @ 4-byte Spill
	ldr	r0, .LCPI52_12
.LPC52_2:
	add	r0, pc, r0
	add	r1, r1, r0
	str	r1, [sp, #24]           @ 4-byte Spill
	ldr	r1, .LCPI52_14
	add	r1, r1, r0
	str	r1, [sp, #20]           @ 4-byte Spill
	ldr	r1, .LCPI52_15
	add	r0, r1, r0
	ldr	r1, .LCPI52_17
	str	r0, [sp, #16]           @ 4-byte Spill
	ldr	r0, .LCPI52_16
.LPC52_3:
	add	r0, pc, r0
	add	r1, r1, r0
	str	r1, [sp, #116]          @ 4-byte Spill
	ldr	r1, .LCPI52_18
	add	r0, r1, r0
	ldr	r1, .LCPI52_19
	str	r0, [sp, #112]          @ 4-byte Spill
	ldr	r0, .LCPI52_20
.LPC52_4:
	add	r1, pc, r1
	add	r7, r0, r1
	ldr	r1, .LCPI52_21
	str	r7, [sp, #120]          @ 4-byte Spill
.LPC52_5:
	add	r1, pc, r1
	add	r1, r2, r1
	ldr	r2, .LCPI52_25
	str	r1, [sp, #108]          @ 4-byte Spill
	ldr	r1, .LCPI52_23
.LPC52_6:
	add	r1, pc, r1
	add	r1, r0, r1
	str	r1, [sp, #104]          @ 4-byte Spill
	ldr	r1, .LCPI52_24
.LPC52_7:
	add	r1, pc, r1
	add	r2, r2, r1
	str	r2, [sp, #100]          @ 4-byte Spill
	ldr	r2, .LCPI52_26
	add	r1, r2, r1
	ldr	r2, .LCPI52_40
	str	r1, [sp, #96]           @ 4-byte Spill
	ldr	r1, .LCPI52_27
.LPC52_8:
	add	r1, pc, r1
	add	r1, r0, r1
	str	r1, [sp, #92]           @ 4-byte Spill
	ldr	r1, .LCPI52_41
.LPC52_17:
	add	r1, pc, r1
	add	r1, r3, r1
	str	r1, [sp, #88]           @ 4-byte Spill
	ldr	r1, .LCPI52_39
.LPC52_16:
	add	r1, pc, r1
	add	r1, r2, r1
	ldr	r2, .LCPI52_32
	str	r1, [sp, #84]           @ 4-byte Spill
	ldr	r1, .LCPI52_31
.LPC52_11:
	add	r1, pc, r1
	add	r1, r2, r1
	ldr	r2, .LCPI52_35
	str	r1, [sp, #80]           @ 4-byte Spill
	ldr	r1, .LCPI52_33
.LPC52_12:
	add	r1, pc, r1
	add	r1, r0, r1
	str	r1, [sp, #76]           @ 4-byte Spill
	ldr	r1, .LCPI52_34
.LPC52_13:
	add	r1, pc, r1
	add	r1, r2, r1
	ldr	r2, .LCPI52_38
	str	r1, [sp, #72]           @ 4-byte Spill
	ldr	r1, .LCPI52_36
.LPC52_14:
	add	r1, pc, r1
	add	r1, r0, r1
	str	r1, [sp, #68]           @ 4-byte Spill
	ldr	r1, .LCPI52_37
.LPC52_15:
	add	r1, pc, r1
	add	r1, r2, r1
	ldr	r2, .LCPI52_29
	str	r1, [sp, #64]           @ 4-byte Spill
	ldr	r1, .LCPI52_28
.LPC52_9:
	add	r1, pc, r1
	add	r1, r2, r1
	str	r1, [sp, #60]           @ 4-byte Spill
	ldr	r1, .LCPI52_30
.LPC52_10:
	add	r1, pc, r1
	add	r0, r0, r1
	ldr	r1, .LCPI52_11
	str	r0, [sp, #56]           @ 4-byte Spill
	ldr	r0, .LCPI52_10
.LPC52_1:
	add	r0, pc, r0
	str	r0, [sp, #12]           @ 4-byte Spill
	add	r0, r1, r0
	str	r0, [sp, #8]            @ 4-byte Spill
	b	.LBB52_4
	.align	3
@ BB#2:
.LCPI52_42:
	.long	3654794683              @ double 1.0E-10
	.long	1037794527
	.align	2
@ BB#3:
.LCPI52_43:
	.long	1232348160              @ float 1.0E+6
.LBB52_4:                               @ %.lr.ph64
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB52_11 Depth 2
                                        @     Child Loop BB52_16 Depth 2
                                        @       Child Loop BB52_19 Depth 3
                                        @       Child Loop BB52_23 Depth 3
                                        @       Child Loop BB52_27 Depth 3
                                        @       Child Loop BB52_32 Depth 3
                                        @       Child Loop BB52_37 Depth 3
                                        @       Child Loop BB52_39 Depth 3
	ldrd	r0, r1, [r10]
	str	r10, [sp, #132]         @ 4-byte Spill
	ldr	r4, [r10, #68]
	bl	__aeabi_ul2f(PLT)
	cmp	r4, #0
	beq	.LBB52_46
@ BB#5:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EE5clearEv.exit
                                        @   in Loop: Header=BB52_4 Depth=1
	strb	r9, [sp, #148]
	mov	r1, r6
	vmov	s0, r0
	ldr	r0, [r10, #32]
	ldr	r2, [r10, #48]
	vdiv.f32	s20, s0, s16
	str	r0, [sp, #144]          @ 4-byte Spill
	ldr	r0, [r10, #36]
	ldr	r5, [r10, #40]
	ldr	r9, [r10, #44]
	str	r0, [sp, #140]          @ 4-byte Spill
	mov	r0, r8
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #52]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #48]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	vcvt.f64.f32	d0, s20
	mov	r1, r6
	mov	r2, #0
	bl	halide_double_to_string(PLT)
	ldr	r2, [sp, #44]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #40]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [r10, #72]
	mov	r1, #1
	mov	r4, r1
	mov	r1, r6
	str	r4, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r2, [sp, #36]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [r10, #68]
	mov	r1, r6
	str	r4, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r2, [sp, #32]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, [r10, #68]
	mov	r2, #0
	vmov	s0, r1
	mov	r1, r6
	vcvt.f32.s32	s0, s0
	vdiv.f32	s0, s20, s0
	vcvt.f64.f32	d0, s0
	bl	halide_double_to_string(PLT)
	ldr	r2, [sp, #28]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #144]          @ 4-byte Reload
	mov	r4, r0
	ldr	r1, [sp, #140]          @ 4-byte Reload
	eor	r3, r2, r5
	eor	r0, r1, r9
	orrs	r0, r3, r0
	str	r0, [sp, #124]          @ 4-byte Spill
	beq	.LBB52_7
@ BB#6:                                 @   in Loop: Header=BB52_4 Depth=1
	mov	r0, r2
	bl	__aeabi_ul2d(PLT)
	str	r0, [sp, #144]          @ 4-byte Spill
	mov	r7, r1
	mov	r0, r5
	mov	r1, r9
	bl	__aeabi_ul2d(PLT)
	vmov	d16, r0, r1
	mov	r1, r6
	ldr	r0, [sp, #144]          @ 4-byte Reload
	vadd.f64	d16, d16, d9
	ldr	r2, [sp, #8]            @ 4-byte Reload
	vmov	d17, r0, r7
	mov	r0, r4
	ldr	r7, [sp, #120]          @ 4-byte Reload
	vdiv.f64	d16, d17, d16
	vcvt.f32.f64	s20, d16
	bl	halide_string_to_string(PLT)
	vcvt.f64.f32	d0, s20
	mov	r1, r6
	mov	r2, #0
	bl	halide_double_to_string(PLT)
	ldr	r1, .LCPI52_2
	ldr	r2, [sp, #12]           @ 4-byte Reload
	add	r2, r1, r2
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r4, r0
.LBB52_7:                               @   in Loop: Header=BB52_4 Depth=1
	ldr	r2, [sp, #24]           @ 4-byte Reload
	mov	r0, r4
	mov	r1, r6
	mov	r9, #0
	bl	halide_string_to_string(PLT)
	ldr	r2, [r10, #76]
	mov	r5, #1
	mov	r1, r6
	str	r5, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r2, [sp, #20]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldrd	r2, r3, [r10, #16]
	mov	r1, r6
	str	r5, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r2, [sp, #16]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r0, [sp, #128]          @ 4-byte Reload
	mov	r1, r8
	bl	halide_print(PLT)
	ldrd	r0, r1, [r10]
	orrs	r0, r0, r1
	bne	.LBB52_14
@ BB#8:                                 @   in Loop: Header=BB52_4 Depth=1
	ldrd	r0, r1, [r10, #24]
	orrs	r0, r0, r1
	bne	.LBB52_14
@ BB#9:                                 @ %.preheader
                                        @   in Loop: Header=BB52_4 Depth=1
	ldr	r0, [r10, #60]
	cmp	r0, #1
	blt	.LBB52_46
@ BB#10:                                @ %.lr.ph
                                        @   in Loop: Header=BB52_4 Depth=1
	ldr	r1, [r10, #52]
	mov	r12, r7
	mov	r3, #1
	add	r2, r1, #32
	mov	r1, #0
.LBB52_11:                              @   Parent Loop BB52_4 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldm	r2, {r4, r7}
	orrs	r7, r4, r7
	movwne	r7, #1
	orr	r1, r1, r7
	bne	.LBB52_13
@ BB#12:                                @   in Loop: Header=BB52_11 Depth=2
	add	r7, r3, #1
	cmp	r3, r0
	add	r2, r2, #64
	mov	r3, r7
	blt	.LBB52_11
.LBB52_13:                              @ %._crit_edge
                                        @   in Loop: Header=BB52_4 Depth=1
	mov	r7, r12
	tst	r1, #1
	beq	.LBB52_46
.LBB52_14:                              @ %.thread19.preheader
                                        @   in Loop: Header=BB52_4 Depth=1
	ldr	r0, [r10, #60]
	cmp	r0, #1
	blt	.LBB52_46
@ BB#15:                                @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EE5clearEv.exit16.lr.ph
                                        @   in Loop: Header=BB52_4 Depth=1
	mov	r4, #0
.LBB52_16:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EE5clearEv.exit16
                                        @   Parent Loop BB52_4 Depth=1
                                        @ =>  This Loop Header: Depth=2
                                        @       Child Loop BB52_19 Depth 3
                                        @       Child Loop BB52_23 Depth 3
                                        @       Child Loop BB52_27 Depth 3
                                        @       Child Loop BB52_32 Depth 3
                                        @       Child Loop BB52_37 Depth 3
                                        @       Child Loop BB52_39 Depth 3
	strb	r9, [sp, #148]
	cmp	r4, #0
	ldr	r0, [r10, #52]
	add	r3, r0, r4, lsl #6
	bne	.LBB52_18
@ BB#17:                                @   in Loop: Header=BB52_16 Depth=2
	ldrd	r0, r1, [r3]
	orrs	r0, r0, r1
	beq	.LBB52_45
.LBB52_18:                              @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #116]          @ 4-byte Reload
	mov	r0, r8
	str	r4, [sp, #140]          @ 4-byte Spill
	mov	r1, r6
	mov	r4, r3
	str	r4, [sp, #144]          @ 4-byte Spill
	bl	halide_string_to_string(PLT)
	ldr	r2, [r4, #56]
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #112]          @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r4, r0
	sub	r0, r4, r8
	cmp	r0, #24
	bhi	.LBB52_20
.LBB52_19:                              @ %.lr.ph30
                                        @   Parent Loop BB52_4 Depth=1
                                        @     Parent Loop BB52_16 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	mov	r0, r4
	mov	r1, r6
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	mov	r4, r0
	sub	r0, r4, r8
	cmp	r0, #25
	blo	.LBB52_19
.LBB52_20:                              @ %._crit_edge.31
                                        @   in Loop: Header=BB52_16 Depth=2
	vldr	s0, [r10, #68]
	vcvt.f32.s32	s0, s0
	ldr	r0, [sp, #144]          @ 4-byte Reload
	ldrd	r0, r1, [r0]
	vmul.f32	s20, s0, s16
	bl	__aeabi_ul2f(PLT)
	vmov	s0, r0
	mov	r0, r4
	vdiv.f32	s0, s0, s20
	mov	r1, r6
	mov	r2, #0
	mov	r7, #0
	vcvt.f64.f32	d0, s0
	bl	halide_double_to_string(PLT)
	cmp	r0, #0
	beq	.LBB52_22
@ BB#21:                                @   in Loop: Header=BB52_16 Depth=2
	sub	r7, r0, #3
	cmp	r7, r8
	movlo	r7, r8
	strb	r9, [r7]
.LBB52_22:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EE5eraseEi.exit
                                        @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #108]          @ 4-byte Reload
	mov	r0, r7
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r7, [sp, #104]          @ 4-byte Reload
	mov	r4, r0
	sub	r0, r4, r8
	cmp	r0, #34
	bhi	.LBB52_24
.LBB52_23:                              @ %.lr.ph34
                                        @   Parent Loop BB52_4 Depth=1
                                        @     Parent Loop BB52_16 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	mov	r0, r4
	mov	r1, r6
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	mov	r4, r0
	sub	r0, r4, r8
	cmp	r0, #35
	blo	.LBB52_23
.LBB52_24:                              @ %._crit_edge.35
                                        @   in Loop: Header=BB52_16 Depth=2
	ldrd	r2, r3, [r10]
	mov	r7, #0
	orrs	r0, r2, r3
	beq	.LBB52_26
@ BB#25:                                @   in Loop: Header=BB52_16 Depth=2
	ldr	r0, [sp, #144]          @ 4-byte Reload
	mov	r5, #100
	ldrd	r0, r1, [r0]
	umull	r0, r7, r0, r5
	mla	r1, r1, r5, r7
	bl	__aeabi_uldivmod(PLT)
	mov	r7, r0
.LBB52_26:                              @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #100]          @ 4-byte Reload
	mov	r0, r4
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r7, #31
	str	r1, [sp]
	mov	r1, r6
	mov	r2, r7
	bl	halide_int64_to_string(PLT)
	ldr	r2, [sp, #96]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r4, [sp, #92]           @ 4-byte Reload
	mov	r9, r0
	sub	r0, r9, r8
	cmp	r0, #42
	bhi	.LBB52_28
.LBB52_27:                              @ %.lr.ph39
                                        @   Parent Loop BB52_4 Depth=1
                                        @     Parent Loop BB52_16 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	mov	r0, r9
	mov	r1, r6
	mov	r2, r4
	bl	halide_string_to_string(PLT)
	mov	r9, r0
	sub	r0, r9, r8
	cmp	r0, #43
	blo	.LBB52_27
.LBB52_28:                              @ %._crit_edge.40
                                        @   in Loop: Header=BB52_16 Depth=2
	ldr	r0, [sp, #124]          @ 4-byte Reload
	mov	r7, #58
	cmp	r0, #0
	beq	.LBB52_33
@ BB#29:                                @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #144]          @ 4-byte Reload
	add	r7, r2, #40
	ldm	r7, {r0, r1, r4, r7}
	bl	__aeabi_ul2d(PLT)
	mov	r10, r0
	mov	r5, r1
	mov	r0, r4
	mov	r1, r7
	bl	__aeabi_ul2d(PLT)
	vmov	d16, r0, r1
	mov	r0, r9
	vadd.f64	d16, d16, d9
	mov	r1, r6
	vmov	d17, r10, r5
	ldr	r2, [sp, #60]           @ 4-byte Reload
	vdiv.f64	d16, d17, d16
	vcvt.f32.f64	s20, d16
	bl	halide_string_to_string(PLT)
	vcvt.f64.f32	d0, s20
	mov	r1, r6
	mov	r2, #0
	mov	r9, #0
	bl	halide_double_to_string(PLT)
	cmp	r0, #0
	beq	.LBB52_31
@ BB#30:                                @   in Loop: Header=BB52_16 Depth=2
	sub	r9, r0, #3
	mov	r0, #0
	cmp	r9, r8
	movlo	r9, r8
	strb	r0, [r9]
.LBB52_31:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EE5eraseEi.exit18.preheader
                                        @   in Loop: Header=BB52_16 Depth=2
	ldr	r4, [sp, #56]           @ 4-byte Reload
	sub	r0, r9, r8
	mov	r7, #73
	cmp	r0, #57
	bhi	.LBB52_33
.LBB52_32:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EE5eraseEi.exit18
                                        @   Parent Loop BB52_4 Depth=1
                                        @     Parent Loop BB52_16 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	mov	r0, r9
	mov	r1, r6
	mov	r2, r4
	bl	halide_string_to_string(PLT)
	mov	r9, r0
	sub	r0, r9, r8
	cmp	r0, #58
	blo	.LBB52_32
.LBB52_33:                              @ %.loopexit
                                        @   in Loop: Header=BB52_16 Depth=2
	ldr	r3, [sp, #144]          @ 4-byte Reload
	mov	r0, #0
	mov	r10, r3
	ldr	r2, [r10, #60]!
	cmp	r2, #0
	beq	.LBB52_35
@ BB#34:                                @   in Loop: Header=BB52_16 Depth=2
	ldrd	r0, r1, [r3, #24]
	mov	r4, r3
	asr	r3, r2, #31
	bl	__aeabi_uldivmod(PLT)
	mov	r3, r4
.LBB52_35:                              @   in Loop: Header=BB52_16 Depth=2
	mov	r4, r3
	ldr	r2, [r4, #16]!
	ldr	r1, [r4, #4]
	orrs	r1, r2, r1
	beq	.LBB52_41
@ BB#36:                                @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #80]           @ 4-byte Reload
	mov	r1, r6
	str	r0, [sp, #136]          @ 4-byte Spill
	mov	r0, r9
	bl	halide_string_to_string(PLT)
	ldrd	r2, r3, [r4]
	mov	r4, #1
	mov	r1, r6
	str	r4, [sp]
	bl	halide_uint64_to_string(PLT)
	sub	r1, r0, r8
	mov	r2, #0
	cmp	r1, r7
	mov	r5, #0
	movwhs	r2, #1
	cmp	r5, r1, asr #31
	movne	r2, r4
	ldr	r4, [sp, #76]           @ 4-byte Reload
	cmp	r2, #0
	bne	.LBB52_38
.LBB52_37:                              @ %.lr.ph49
                                        @   Parent Loop BB52_4 Depth=1
                                        @     Parent Loop BB52_16 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	mov	r1, r6
	mov	r2, r4
	bl	halide_string_to_string(PLT)
	sub	r1, r0, r8
	mov	r2, #0
	cmp	r1, r7
	movwlo	r2, #1
	cmp	r5, r1, asr #31
	movne	r2, r5
	cmp	r2, #0
	bne	.LBB52_37
.LBB52_38:                              @ %._crit_edge.50
                                        @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #72]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [r10]
	mov	r9, #1
	mov	r1, r6
	str	r9, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	add	r4, r7, #15
	sub	r1, r0, r8
	cmp	r1, r4
	mov	r2, #0
	movwhs	r2, #1
	cmp	r5, r1, asr #31
	ldr	r7, [sp, #68]           @ 4-byte Reload
	movne	r2, r9
	cmp	r2, #0
	bne	.LBB52_40
.LBB52_39:                              @ %.lr.ph55
                                        @   Parent Loop BB52_4 Depth=1
                                        @     Parent Loop BB52_16 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	mov	r1, r6
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	sub	r1, r0, r8
	mov	r2, #0
	cmp	r1, r4
	movwlo	r2, #1
	cmp	r5, r1, asr #31
	movne	r2, r5
	cmp	r2, #0
	bne	.LBB52_39
.LBB52_40:                              @ %._crit_edge.56
                                        @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #64]           @ 4-byte Reload
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #136]          @ 4-byte Reload
	mov	r1, #1
	str	r1, [sp]
	mov	r1, r6
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r10, [sp, #132]         @ 4-byte Reload
	mov	r9, r0
	ldr	r7, [sp, #120]          @ 4-byte Reload
	ldr	r4, [sp, #140]          @ 4-byte Reload
	ldr	r3, [sp, #144]          @ 4-byte Reload
	b	.LBB52_42
.LBB52_41:                              @   in Loop: Header=BB52_16 Depth=2
	ldr	r10, [sp, #132]         @ 4-byte Reload
	ldr	r7, [sp, #120]          @ 4-byte Reload
	ldr	r4, [sp, #140]          @ 4-byte Reload
.LBB52_42:                              @   in Loop: Header=BB52_16 Depth=2
	ldr	r0, [r3, #32]!
	ldr	r1, [r3, #4]
	orrs	r0, r0, r1
	beq	.LBB52_44
@ BB#43:                                @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #84]           @ 4-byte Reload
	mov	r0, r9
	mov	r1, r6
	mov	r5, r3
	bl	halide_string_to_string(PLT)
	ldrd	r2, r3, [r5]
	mov	r1, #1
	str	r1, [sp]
	mov	r1, r6
	bl	halide_uint64_to_string(PLT)
	mov	r9, r0
.LBB52_44:                              @   in Loop: Header=BB52_16 Depth=2
	ldr	r2, [sp, #88]           @ 4-byte Reload
	mov	r0, r9
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r0, [sp, #128]          @ 4-byte Reload
	mov	r1, r8
	bl	halide_print(PLT)
	mov	r9, #0
.LBB52_45:                              @ %.thread19
                                        @   in Loop: Header=BB52_16 Depth=2
	ldr	r0, [r10, #60]
	add	r4, r4, #1
	cmp	r4, r0
	blt	.LBB52_16
.LBB52_46:                              @ %.loopexit23
                                        @   in Loop: Header=BB52_4 Depth=1
	ldr	r10, [r10, #56]
	cmp	r10, #0
	bne	.LBB52_4
.LBB52_47:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EED2Ev.exit
	sub	sp, r11, #56
	vpop	{d8, d9, d10}
	add	sp, sp, #4
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#48:
.LCPI52_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_0+8)
.LCPI52_2:
	.long	.L.str.25.54(GOTOFF)
.LCPI52_3:
	.long	.L.str.8.17(GOTOFF)
.LCPI52_4:
	.long	.L.str.9(GOTOFF)
.LCPI52_5:
	.long	.L.str.10(GOTOFF)
.LCPI52_6:
	.long	.L.str.11(GOTOFF)
.LCPI52_7:
	.long	.L.str.12(GOTOFF)
.LCPI52_8:
	.long	.L.str.13.18(GOTOFF)
.LCPI52_10:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_1+8)
.LCPI52_11:
	.long	.L.str.14(GOTOFF)
.LCPI52_12:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_2+8)
.LCPI52_13:
	.long	.L.str.15(GOTOFF)
.LCPI52_14:
	.long	.L.str.16(GOTOFF)
.LCPI52_15:
	.long	.L.str.17(GOTOFF)
.LCPI52_16:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_3+8)
.LCPI52_17:
	.long	.L.str.18(GOTOFF)
.LCPI52_18:
	.long	.L.str.19(GOTOFF)
.LCPI52_19:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_4+8)
.LCPI52_20:
	.long	.L.str.13.42(GOTOFF)
.LCPI52_21:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_5+8)
.LCPI52_22:
	.long	.L.str.21(GOTOFF)
.LCPI52_23:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_6+8)
.LCPI52_24:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_7+8)
.LCPI52_25:
	.long	.L.str.15.44(GOTOFF)
.LCPI52_26:
	.long	.L.str.23(GOTOFF)
.LCPI52_27:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_8+8)
.LCPI52_28:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_9+8)
.LCPI52_29:
	.long	.L.str.24(GOTOFF)
.LCPI52_30:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_10+8)
.LCPI52_31:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_11+8)
.LCPI52_32:
	.long	.L.str.25(GOTOFF)
.LCPI52_33:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_12+8)
.LCPI52_34:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_13+8)
.LCPI52_35:
	.long	.L.str.26(GOTOFF)
.LCPI52_36:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_14+8)
.LCPI52_37:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_15+8)
.LCPI52_38:
	.long	.L.str.27(GOTOFF)
.LCPI52_39:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_16+8)
.LCPI52_40:
	.long	.L.str.28(GOTOFF)
.LCPI52_41:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC52_17+8)
.Lfunc_end52:
	.size	halide_profiler_report_unlocked, .Lfunc_end52-halide_profiler_report_unlocked
	.cantunwind
	.fnend

	.section	.text.halide_profiler_report,"ax",%progbits
	.weak	halide_profiler_report
	.align	2
	.type	halide_profiler_report,%function
halide_profiler_report:                 @ @halide_profiler_report
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	bl	halide_profiler_get_state(PLT)
	mov	r5, r0
	bl	halide_mutex_lock(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_profiler_report_unlocked(PLT)
	mov	r0, r5
	pop	{r4, r5, r11, lr}
	b	halide_mutex_unlock(PLT)
.Lfunc_end53:
	.size	halide_profiler_report, .Lfunc_end53-halide_profiler_report
	.cantunwind
	.fnend

	.section	.text.halide_profiler_reset,"ax",%progbits
	.weak	halide_profiler_reset
	.align	2
	.type	halide_profiler_reset,%function
halide_profiler_reset:                  @ @halide_profiler_reset
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	bl	halide_profiler_get_state(PLT)
	mov	r4, r0
	bl	halide_mutex_lock(PLT)
	b	.LBB54_2
.LBB54_1:                               @ %.lr.ph
                                        @   in Loop: Header=BB54_2 Depth=1
	ldr	r0, [r5, #56]
	str	r0, [r4, #80]
	ldr	r0, [r5, #52]
	bl	free(PLT)
	mov	r0, r5
	bl	free(PLT)
.LBB54_2:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r5, [r4, #80]
	cmp	r5, #0
	bne	.LBB54_1
@ BB#3:                                 @ %._crit_edge
	mov	r0, #0
	str	r0, [r4, #68]
	mov	r0, r4
	pop	{r4, r5, r11, lr}
	b	halide_mutex_unlock(PLT)
.Lfunc_end54:
	.size	halide_profiler_reset, .Lfunc_end54-halide_profiler_reset
	.cantunwind
	.fnend

	.section	.text.halide_profiler_shutdown,"ax",%progbits
	.weak	halide_profiler_shutdown
	.align	2
	.type	halide_profiler_shutdown,%function
halide_profiler_shutdown:               @ @halide_profiler_shutdown
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	.setfp	r11, sp
	mov	r11, sp
	bl	halide_profiler_get_state(PLT)
	mov	r1, r0
	ldrb	r0, [r1, #88]
	cmp	r0, #0
	beq	.LBB55_4
@ BB#1:
	mvn	r0, #1
	str	r0, [r1, #72]
.LBB55_2:                               @ =>This Inner Loop Header: Depth=1
	dmb	ish
	ldrb	r0, [r1, #88]
	cmp	r0, #0
	bne	.LBB55_2
@ BB#3:
	mvn	r0, #0
	str	r0, [r1, #72]
	mov	r0, #0
	pop	{r11, lr}
	b	halide_profiler_report_unlocked(PLT)
.LBB55_4:
	pop	{r11, pc}
.Lfunc_end55:
	.size	halide_profiler_shutdown, .Lfunc_end55-halide_profiler_shutdown
	.cantunwind
	.fnend

	.section	.text.halide_profiler_pipeline_end,"ax",%progbits
	.weak	halide_profiler_pipeline_end
	.align	2
	.type	halide_profiler_pipeline_end,%function
halide_profiler_pipeline_end:           @ @halide_profiler_pipeline_end
	.fnstart
@ BB#0:
	mvn	r0, #0
	str	r0, [r1, #72]
	bx	lr
.Lfunc_end56:
	.size	halide_profiler_pipeline_end, .Lfunc_end56-halide_profiler_pipeline_end
	.cantunwind
	.fnend

	.section	.text.halide_set_gpu_device,"ax",%progbits
	.weak	halide_set_gpu_device
	.align	2
	.type	halide_set_gpu_device,%function
halide_set_gpu_device:                  @ @halide_set_gpu_device
	.fnstart
@ BB#0:
	ldr	r2, .LCPI57_1
	ldr	r1, .LCPI57_0
	ldr	r3, .LCPI57_2
.LPC57_0:
	add	r2, pc, r2
	ldr	r1, [r1, r2]
	ldr	r2, [r3, r2]
	str	r0, [r1]
	mov	r0, #1
	strb	r0, [r2]
	bx	lr
	.align	2
@ BB#1:
.LCPI57_0:
	.long	_ZN6Halide7Runtime8Internal17halide_gpu_deviceE(GOT)
.LCPI57_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC57_0+8)
.LCPI57_2:
	.long	_ZN6Halide7Runtime8Internal29halide_gpu_device_initializedE(GOT)
.Lfunc_end57:
	.size	halide_set_gpu_device, .Lfunc_end57-halide_set_gpu_device
	.cantunwind
	.fnend

	.section	.text.halide_get_gpu_device,"ax",%progbits
	.weak	halide_get_gpu_device
	.align	2
	.type	halide_get_gpu_device,%function
halide_get_gpu_device:                  @ @halide_get_gpu_device
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	ldr	r0, .LCPI58_1
	mov	r1, #1
	ldr	r4, .LCPI58_0
.LPC58_0:
	add	r0, pc, r0
	ldr	r0, [r4, r0]
.LBB58_1:                               @ %._crit_edge.i
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB58_2 Depth 2
	dmb	ish
.LBB58_2:                               @ %atomicrmw.start
                                        @   Parent Loop BB58_1 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrex	r2, [r0]
	strex	r3, r1, [r0]
	cmp	r3, #0
	bne	.LBB58_2
@ BB#3:                                 @ %atomicrmw.end
                                        @   in Loop: Header=BB58_1 Depth=1
	dmb	ish
	cmp	r2, #0
	bne	.LBB58_1
@ BB#4:                                 @ %_ZN6Halide7Runtime8Internal14ScopedSpinLockC2EPVi.exit
	ldr	r0, .LCPI58_3
	ldr	r5, .LCPI58_2
.LPC58_1:
	add	r0, pc, r0
	ldr	r0, [r5, r0]
	ldrb	r0, [r0]
	cmp	r0, #0
	beq	.LBB58_6
@ BB#5:                                 @ %_ZN6Halide7Runtime8Internal14ScopedSpinLockC2EPVi.exit._crit_edge
	ldr	r1, .LCPI58_5
	ldr	r0, .LCPI58_4
.LPC58_2:
	add	r1, pc, r1
	ldr	r0, [r0, r1]
	ldr	r0, [r0]
	b	.LBB58_9
.LBB58_6:
	ldr	r0, .LCPI58_6
	ldr	r1, .LCPI58_7
.LPC58_3:
	add	r0, pc, r0
	add	r0, r1, r0
	bl	getenv(PLT)
	mov	r1, r0
	mvn	r0, #0
	cmp	r1, #0
	beq	.LBB58_8
@ BB#7:
	mov	r0, r1
	bl	atoi(PLT)
.LBB58_8:
	ldr	r2, .LCPI58_8
	ldr	r1, .LCPI58_4
.LPC58_4:
	add	r2, pc, r2
	ldr	r1, [r1, r2]
	ldr	r2, [r5, r2]
	str	r0, [r1]
	mov	r1, #1
	strb	r1, [r2]
.LBB58_9:
	ldr	r1, .LCPI58_9
	mov	r2, #0
	dmb	ish
.LPC58_5:
	add	r1, pc, r1
	ldr	r1, [r4, r1]
	str	r2, [r1]
	pop	{r4, r5, r11, pc}
	.align	2
@ BB#10:
.LCPI58_0:
	.long	_ZN6Halide7Runtime8Internal22halide_gpu_device_lockE(GOT)
.LCPI58_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC58_0+8)
.LCPI58_2:
	.long	_ZN6Halide7Runtime8Internal29halide_gpu_device_initializedE(GOT)
.LCPI58_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC58_1+8)
.LCPI58_4:
	.long	_ZN6Halide7Runtime8Internal17halide_gpu_deviceE(GOT)
.LCPI58_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC58_2+8)
.LCPI58_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC58_3+8)
.LCPI58_7:
	.long	.L.str.29(GOTOFF)
.LCPI58_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC58_4+8)
.LCPI58_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC58_5+8)
.Lfunc_end58:
	.size	halide_get_gpu_device, .Lfunc_end58-halide_get_gpu_device
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_event,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_event
	.align	2
	.type	_ZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_event,%function
_ZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_event: @ @_ZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_event
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#44
	sub	sp, sp, #44
	.pad	#4096
	sub	sp, sp, #4096
	mov	r10, r0
	ldr	r0, .LCPI59_0
	mov	r6, r1
	ldr	r1, .LCPI59_1
.LPC59_0:
	add	r0, pc, r0
	dmb	ish
	add	r0, r1, r0
.LBB59_1:                               @ %atomicrmw.start
                                        @ =>This Inner Loop Header: Depth=1
	ldrex	r4, [r0]
	add	r1, r4, #1
	strex	r2, r1, [r0]
	cmp	r2, #0
	bne	.LBB59_1
@ BB#2:                                 @ %atomicrmw.end
	mov	r0, r10
	dmb	ish
	bl	halide_get_trace_file(PLT)
	cmp	r0, #1
	blt	.LBB59_15
@ BB#3:
	str	r0, [sp, #36]           @ 4-byte Spill
	mov	r8, r6
	ldrb	r0, [r6, #13]
	mov	r2, #1
	ldrh	r7, [r6, #14]
	ldr	r1, [r6, #24]
.LBB59_4:                               @ =>This Inner Loop Header: Depth=1
	mov	r5, r2
	lsl	r3, r5, #3
	lsl	r2, r5, #1
	cmp	r3, r0
	blt	.LBB59_4
@ BB#5:
	mvn	r3, #0
	cmp	r7, #256
	movhs	r7, r3
	cmp	r1, #256
	uxtb	r2, r7
	movlt	r3, r1
	uxtb	r6, r3
	mul	r9, r5, r2
	str	r2, [sp, #20]           @ 4-byte Spill
	add	r1, r9, #48
	str	r1, [sp, #16]           @ 4-byte Spill
	add	r1, r1, r6, lsl #2
	str	r1, [sp, #28]           @ 4-byte Spill
	cmp	r1, #4096
	bls	.LBB59_7
@ BB#6:
	ldr	r0, .LCPI59_35
	ldr	r1, .LCPI59_36
.LPC59_17:
	add	r0, pc, r0
	str	r10, [sp, #32]          @ 4-byte Spill
	add	r1, r1, r0
	mov	r0, r10
	mov	r10, r3
	bl	halide_print(PLT)
	bl	abort(PLT)
	ldrb	r0, [r8, #13]
	mov	r3, r10
	ldr	r10, [sp, #32]          @ 4-byte Reload
.LBB59_7:
	lsl	lr, r6, #2
	str	r6, [sp, #12]           @ 4-byte Spill
	mov	r6, r8
	str	r4, [sp, #40]
	ldr	r1, [r6, #8]
	mov	r8, #14
	str	r3, [sp, #24]           @ 4-byte Spill
	str	r1, [sp, #44]
	ldr	r1, [r6, #4]
	strb	r1, [sp, #48]
	ldrb	r1, [r6, #12]
	strb	r1, [sp, #49]
	strb	r0, [sp, #50]
	strb	r7, [sp, #51]
	ldr	r0, [r6, #16]
	strb	r0, [sp, #52]
	strb	r3, [sp, #53]
	add	r3, sp, #40
	ldr	r0, [r6]
.LBB59_8:                               @ =>This Inner Loop Header: Depth=1
	ldrb	r1, [r0]
	cmp	r1, #0
	strb	r1, [r3, r8]
	beq	.LBB59_11
@ BB#9:                                 @   in Loop: Header=BB59_8 Depth=1
	add	r8, r8, #1
	add	r0, r0, #1
	cmp	r8, #47
	blo	.LBB59_8
@ BB#10:                                @ %.preheader13
	mov	r8, #47
	bhi	.LBB59_34
.LBB59_11:                              @ %.lr.ph21.preheader
	str	r10, [sp, #32]          @ 4-byte Spill
	add	r10, r8, #1
	mov	r2, #48
	cmp	r10, #48
	movls	r10, r2
	mvn	r0, r8
	add	r0, r10, r0
	cmn	r0, #1
	beq	.LBB59_32
@ BB#12:                                @ %overflow.checked
	sub	r7, r10, r8
	str	lr, [sp, #8]            @ 4-byte Spill
	bfc	r7, #0, #2
	cmp	r7, #0
	beq	.LBB59_14
@ BB#13:                                @ %vector.body.preheader
	add	r0, r3, r8
	mov	r1, r7
	bl	__aeabi_memclr(PLT)
	mov	r2, #48
	add	r8, r7, r8
.LBB59_14:                              @ %middle.block
	cmp	r10, r8
	ldr	lr, [sp, #8]            @ 4-byte Reload
	ldr	r10, [sp, #32]          @ 4-byte Reload
	add	r3, sp, #40
	bne	.LBB59_33
	b	.LBB59_34
.LBB59_15:
	mov	r0, r10
	mov	r1, #1024
	str	r10, [sp, #32]          @ 4-byte Spill
	bl	halide_malloc(PLT)
	mov	r9, r0
	mov	r7, #0
	cmp	r9, #0
	beq	.LBB59_17
@ BB#16:
	mov	r0, #0
	mov	r7, r9
	strb	r0, [r7, #1023]!
.LBB59_17:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EEC2EPvPc.exit
	ldrb	r0, [r6, #13]
	mov	r1, #8
.LBB59_18:                              @ =>This Inner Loop Header: Depth=1
	mov	r10, r1
	lsl	r1, r10, #1
	cmp	r10, r0
	blt	.LBB59_18
@ BB#19:
	cmp	r10, #65
	blt	.LBB59_21
@ BB#20:
	ldr	r0, .LCPI59_2
	ldr	r1, .LCPI59_3
.LPC59_1:
	add	r0, pc, r0
	add	r1, r1, r0
	ldr	r0, [sp, #32]           @ 4-byte Reload
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB59_21:
	ldr	r1, .LCPI59_5
	ldr	r0, .LCPI59_4
	ldr	r8, [r6, #4]
.LPC59_2:
	add	r5, pc, r1
	add	r0, r0, r5
	mov	r1, r7
	ldr	r2, [r0, r8, lsl #2]
	mov	r0, r9
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI59_6
	add	r2, r1, r5
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r2, [r6]
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI59_7
	add	r2, r1, r5
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r2, [r6, #16]
	mov	r1, #1
	str	r1, [sp]
	mov	r1, r7
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI59_8
	add	r2, r1, r5
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r5, r0
	ldrh	r0, [r6, #14]
	cmp	r0, #2
	blo	.LBB59_23
@ BB#22:
	ldr	r0, .LCPI59_9
	ldr	r1, .LCPI59_10
.LPC59_3:
	add	r0, pc, r0
	add	r2, r1, r0
	mov	r0, r5
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r5, r0
.LBB59_23:                              @ %.preheader15
	ldr	r0, [r6, #24]
	cmp	r0, #1
	blt	.LBB59_41
@ BB#24:                                @ %.lr.ph30
	ldr	r0, .LCPI59_13
	ldr	r1, .LCPI59_14
.LPC59_5:
	add	r0, pc, r0
	str	r8, [sp, #20]           @ 4-byte Spill
	add	r0, r1, r0
	ldr	r1, .LCPI59_12
	str	r0, [sp, #28]           @ 4-byte Spill
	mov	r8, r7
	ldr	r0, .LCPI59_11
	mov	r7, #0
	str	r9, [sp, #24]           @ 4-byte Spill
	mov	r9, #0
.LPC59_4:
	add	r0, pc, r0
	add	r0, r1, r0
	str	r0, [sp, #36]           @ 4-byte Spill
.LBB59_25:                              @ =>This Inner Loop Header: Depth=1
	cmp	r9, #1
	blt	.LBB59_31
@ BB#26:                                @   in Loop: Header=BB59_25 Depth=1
	ldrh	r1, [r6, #14]
	cmp	r1, #2
	blo	.LBB59_28
@ BB#27:                                @   in Loop: Header=BB59_25 Depth=1
	mov	r0, r9
	bl	__modsi3(PLT)
	cmp	r0, #0
	beq	.LBB59_29
.LBB59_28:                              @   in Loop: Header=BB59_25 Depth=1
	ldr	r2, [sp, #36]           @ 4-byte Reload
	mov	r0, r5
	mov	r1, r8
	b	.LBB59_30
.LBB59_29:                              @   in Loop: Header=BB59_25 Depth=1
	mov	r0, r5
	mov	r1, r8
	ldr	r2, [sp, #28]           @ 4-byte Reload
.LBB59_30:                              @   in Loop: Header=BB59_25 Depth=1
	bl	halide_string_to_string(PLT)
	mov	r5, r0
.LBB59_31:                              @   in Loop: Header=BB59_25 Depth=1
	ldr	r0, [r6, #28]
	mov	r1, r8
	ldr	r2, [r0, r7]
	mov	r0, #1
	str	r0, [sp]
	mov	r0, r5
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	mov	r5, r0
	ldr	r0, [r6, #24]
	add	r9, r9, #1
	add	r7, r7, #4
	cmp	r9, r0
	blt	.LBB59_25
	b	.LBB59_42
.LBB59_32:
	ldr	r10, [sp, #32]          @ 4-byte Reload
.LBB59_33:                              @ %.lr.ph21.preheader3
	add	r1, r8, #1
	add	r0, r3, r8
	cmp	r1, #48
	mov	r7, lr
	movhi	r2, r1
	sub	r1, r2, r8
	mov	r8, r6
	mov	r6, r3
	bl	__aeabi_memclr(PLT)
	mov	r3, r6
	mov	r6, r8
	mov	lr, r7
.LBB59_34:                              @ %.preheader12
	cmp	r9, #0
	beq	.LBB59_53
@ BB#35:                                @ %overflow.checked49
	mov	r12, r9
	ldr	r7, [r6, #20]
	bfc	r12, #0, #2
	mov	r2, #0
	cmp	r12, #0
	beq	.LBB59_49
@ BB#36:                                @ %vector.memcheck
	add	r0, r9, r3
	mov	r8, r3
	add	r0, r0, #47
	add	r3, r8, #48
	cmp	r7, r0
	bhi	.LBB59_38
@ BB#37:                                @ %vector.memcheck
	add	r0, r9, r7
	sub	r0, r0, #1
	cmp	r3, r0
	bls	.LBB59_50
.LBB59_38:                              @ %vector.body45.preheader
	mov	r2, r9
	mov	r0, r7
	bfc	r2, #0, #2
.LBB59_39:                              @ %vector.body45
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r1, [r0], #4
	subs	r2, r2, #4
	str	r1, [r3], #4
	bne	.LBB59_39
@ BB#40:
	mov	r2, r12
	b	.LBB59_50
.LBB59_41:
	str	r8, [sp, #20]           @ 4-byte Spill
	mov	r8, r7
	str	r9, [sp, #24]           @ 4-byte Spill
.LBB59_42:                              @ %._crit_edge.31
	ldrh	r0, [r6, #14]
	ldr	r9, [sp, #24]           @ 4-byte Reload
	cmp	r0, #1
	bls	.LBB59_44
@ BB#43:
	ldr	r0, .LCPI59_17
	ldr	r1, .LCPI59_18
.LPC59_7:
	add	r0, pc, r0
	b	.LBB59_45
.LBB59_44:
	ldr	r0, .LCPI59_15
	ldr	r1, .LCPI59_16
.LPC59_6:
	add	r0, pc, r0
.LBB59_45:
	add	r2, r1, r0
	mov	r0, r5
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r12, r0
	ldr	r0, [sp, #20]           @ 4-byte Reload
	cmp	r0, #1
	bgt	.LBB59_48
@ BB#46:
	ldrh	r0, [r6, #14]
	cmp	r0, #2
	blo	.LBB59_70
@ BB#47:
	ldr	r0, .LCPI59_21
	ldr	r1, .LCPI59_22
.LPC59_9:
	add	r0, pc, r0
	b	.LBB59_71
.LBB59_48:
	ldr	r6, [sp, #32]           @ 4-byte Reload
	b	.LBB59_110
.LBB59_49:
	mov	r8, r3
.LBB59_50:                              @ %middle.block46
	mov	r3, r8
	cmp	r9, r2
	beq	.LBB59_53
@ BB#51:                                @ %scalar.ph47.preheader
	add	r0, r3, #48
.LBB59_52:                              @ %scalar.ph47
                                        @ =>This Inner Loop Header: Depth=1
	ldrb	r1, [r7, r2]
	strb	r1, [r0, r2]
	add	r2, r2, #1
	cmp	r2, r9
	blo	.LBB59_52
.LBB59_53:                              @ %.preheader
	ldr	r0, [sp, #24]           @ 4-byte Reload
	tst	r0, #255
	beq	.LBB59_64
@ BB#54:                                @ %.lr.ph
	ldr	r6, [r6, #28]
	cmp	lr, #1
	mov	r1, lr
	mov	r2, #0
	movls	r1, #1
	cmp	r1, #0
	beq	.LBB59_62
@ BB#55:                                @ %overflow.checked76
	ands	r12, r1, #1020
	mov	r2, #0
	beq	.LBB59_61
@ BB#56:                                @ %vector.memcheck91
	add	r0, r1, r9
	add	r0, r0, r3
	add	r0, r0, #47
	cmp	r6, r0
	bhi	.LBB59_58
@ BB#57:                                @ %vector.memcheck91
	ldr	r0, [sp, #16]           @ 4-byte Reload
	add	r7, r1, r6
	sub	r7, r7, #1
	add	r0, r3, r0
	cmp	r0, r7
	bls	.LBB59_61
.LBB59_58:                              @ %vector.body72.preheader
	ldr	r0, [sp, #20]           @ 4-byte Reload
	mov	r8, r3
	mov	r2, #1
	cmp	lr, #1
	mla	r0, r5, r0, r3
	ldr	r3, [sp, #12]           @ 4-byte Reload
	lslhi	r2, r3, #2
	add	r7, r0, #48
	and	r2, r2, #1020
	mov	r0, r6
.LBB59_59:                              @ %vector.body72
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r3, [r0], #4
	subs	r2, r2, #4
	str	r3, [r7], #4
	bne	.LBB59_59
@ BB#60:
	mov	r2, r12
	mov	r3, r8
.LBB59_61:                              @ %middle.block73
	cmp	r1, r2
	beq	.LBB59_64
.LBB59_62:                              @ %scalar.ph74.preheader
	ldr	r0, [sp, #20]           @ 4-byte Reload
	mla	r0, r5, r0, r3
	add	r0, r0, #48
.LBB59_63:                              @ %scalar.ph74
                                        @ =>This Inner Loop Header: Depth=1
	ldrb	r1, [r6, r2]
	strb	r1, [r0, r2]
	add	r2, r2, #1
	cmp	r2, lr
	blo	.LBB59_63
.LBB59_64:                              @ %._crit_edge.i
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB59_65 Depth 2
	ldr	r0, .LCPI59_37
	mov	r2, #1
	ldr	r5, .LCPI59_30
	dmb	ish
.LPC59_18:
	add	r0, pc, r0
	ldr	r0, [r5, r0]
.LBB59_65:                              @ %atomicrmw.start32
                                        @   Parent Loop BB59_64 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrex	r1, [r0]
	strex	r3, r2, [r0]
	cmp	r3, #0
	bne	.LBB59_65
@ BB#66:                                @ %atomicrmw.end31
                                        @   in Loop: Header=BB59_64 Depth=1
	dmb	ish
	cmp	r1, #0
	bne	.LBB59_64
@ BB#67:                                @ %_ZN6Halide7Runtime8Internal14ScopedSpinLockC2EPVi.exit
	ldr	r6, [sp, #28]           @ 4-byte Reload
	add	r1, sp, #40
	ldr	r0, [sp, #36]           @ 4-byte Reload
	mov	r2, r6
	bl	write(PLT)
	cmp	r0, r6
	beq	.LBB59_69
@ BB#68:
	ldr	r0, .LCPI59_38
	ldr	r1, .LCPI59_39
.LPC59_19:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r10
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB59_69:
	ldr	r0, .LCPI59_40
	mov	r1, #0
	dmb	ish
.LPC59_20:
	add	r0, pc, r0
	ldr	r0, [r5, r0]
	str	r1, [r0]
	b	.LBB59_117
.LBB59_70:
	ldr	r0, .LCPI59_19
	ldr	r1, .LCPI59_20
.LPC59_8:
	add	r0, pc, r0
.LBB59_71:                              @ %.preheader14
	add	r2, r1, r0
	mov	r0, r12
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r12, r0
	ldrh	r0, [r6, #14]
	cmp	r0, #0
	beq	.LBB59_108
@ BB#72:                                @ %.lr.ph26
	ldr	r0, .LCPI59_23
	mov	r5, #0
	ldr	r1, .LCPI59_12
	mov	r9, #0
.LPC59_10:
	add	r0, pc, r0
	str	r8, [sp, #36]           @ 4-byte Spill
	add	r0, r1, r0
	ldr	r1, .LCPI59_25
	str	r0, [sp, #28]           @ 4-byte Spill
	mov	r8, #0
	ldr	r0, .LCPI59_24
	mov	r7, #0
.LPC59_11:
	add	r0, pc, r0
	add	r0, r1, r0
	str	r0, [sp, #16]           @ 4-byte Spill
	b	.LBB59_77
.LBB59_73:                              @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	cmp	r10, #32
	bne	.LBB59_76
@ BB#74:                                @   in Loop: Header=BB59_77 Depth=1
	ldr	r2, [r0, r9]
	mov	r0, #1
	ldr	r1, [sp, #36]           @ 4-byte Reload
	mov	r3, #0
	str	r0, [sp]
	mov	r0, r12
	bl	halide_uint64_to_string(PLT)
	b	.LBB59_104
.LBB59_75:                              @   in Loop: Header=BB59_77 Depth=1
	ldr	r2, [r0, r8]!
	ldr	r3, [r0, #4]
	mov	r0, #1
	str	r0, [sp]
	b	.LBB59_103
.LBB59_76:                              @   in Loop: Header=BB59_77 Depth=1
	ldr	r2, [r0, r8]!
	ldr	r1, [sp, #36]           @ 4-byte Reload
	ldr	r3, [r0, #4]
	mov	r0, #1
	str	r0, [sp]
	mov	r0, r12
	bl	halide_uint64_to_string(PLT)
	b	.LBB59_104
.LBB59_77:                              @ =>This Inner Loop Header: Depth=1
	cmp	r7, #1
	blt	.LBB59_79
@ BB#78:                                @   in Loop: Header=BB59_77 Depth=1
	ldr	r1, [sp, #36]           @ 4-byte Reload
	mov	r0, r12
	ldr	r2, [sp, #28]           @ 4-byte Reload
	bl	halide_string_to_string(PLT)
	mov	r12, r0
.LBB59_79:                              @   in Loop: Header=BB59_77 Depth=1
	ldrb	r0, [r6, #12]
	cmp	r0, #3
	bhi	.LBB59_105
@ BB#80:                                @   in Loop: Header=BB59_77 Depth=1
	lsl	r0, r0, #2
	adr	r1, .LJTI59_0
	ldr	r0, [r0, r1]
	add	pc, r0, r1
@ BB#81:
	.align	2
.LJTI59_0:
	.long	.LBB59_82-.LJTI59_0
	.long	.LBB59_84-.LJTI59_0
	.long	.LBB59_86-.LJTI59_0
	.long	.LBB59_89-.LJTI59_0
.LBB59_82:                              @   in Loop: Header=BB59_77 Depth=1
	cmp	r10, #16
	bne	.LBB59_90
@ BB#83:                                @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	add	r0, r0, r5
	ldrsh	r2, [r0]
	b	.LBB59_102
.LBB59_84:                              @   in Loop: Header=BB59_77 Depth=1
	cmp	r10, #16
	bne	.LBB59_92
@ BB#85:                                @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	add	r0, r0, r5
	ldrh	r2, [r0]
	b	.LBB59_94
.LBB59_86:                              @   in Loop: Header=BB59_77 Depth=1
	cmp	r10, #15
	ble	.LBB59_95
@ BB#87:                                @   in Loop: Header=BB59_77 Depth=1
	cmp	r10, #32
	bne	.LBB59_96
@ BB#88:                                @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	mov	r2, #0
	ldr	r1, [sp, #36]           @ 4-byte Reload
	add	r0, r0, r9
	vldr	s0, [r0]
	mov	r0, r12
	vcvt.f64.f32	d0, s0
	bl	halide_double_to_string(PLT)
	b	.LBB59_104
.LBB59_89:                              @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	ldr	r1, [sp, #36]           @ 4-byte Reload
	ldr	r2, [r0, r9]
	mov	r0, r12
	bl	halide_pointer_to_string(PLT)
	b	.LBB59_104
.LBB59_90:                              @   in Loop: Header=BB59_77 Depth=1
	cmp	r10, #8
	bne	.LBB59_100
@ BB#91:                                @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	add	r0, r0, r7
	ldrsb	r2, [r0]
	b	.LBB59_102
.LBB59_92:                              @   in Loop: Header=BB59_77 Depth=1
	cmp	r10, #8
	bne	.LBB59_73
@ BB#93:                                @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	ldrb	r2, [r0, r7]
.LBB59_94:                              @   in Loop: Header=BB59_77 Depth=1
	ldr	r1, [sp, #36]           @ 4-byte Reload
	mov	r0, #1
	str	r0, [sp]
	mov	r0, r12
	mov	r3, #0
	bl	halide_int64_to_string(PLT)
	b	.LBB59_104
.LBB59_95:                              @ %.thread11
                                        @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [sp, #32]           @ 4-byte Reload
	ldr	r1, [sp, #16]           @ 4-byte Reload
	str	r12, [sp, #20]          @ 4-byte Spill
	bl	halide_print(PLT)
	bl	abort(PLT)
	ldr	r0, [r6, #20]
	b	.LBB59_98
.LBB59_96:                              @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	cmp	r10, #16
	str	r12, [sp, #20]          @ 4-byte Spill
	bne	.LBB59_98
@ BB#97:                                @   in Loop: Header=BB59_77 Depth=1
	add	r0, r0, r5
	ldrh	r0, [r0]
	bl	halide_float16_bits_to_double(PLT)
	b	.LBB59_99
.LBB59_98:                              @   in Loop: Header=BB59_77 Depth=1
	add	r0, r0, r8
	vldr	d0, [r0]
.LBB59_99:                              @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [sp, #20]           @ 4-byte Reload
	mov	r2, #1
	ldr	r1, [sp, #36]           @ 4-byte Reload
	bl	halide_double_to_string(PLT)
	b	.LBB59_104
.LBB59_100:                             @   in Loop: Header=BB59_77 Depth=1
	ldr	r0, [r6, #20]
	cmp	r10, #32
	bne	.LBB59_75
@ BB#101:                               @   in Loop: Header=BB59_77 Depth=1
	ldr	r2, [r0, r9]
.LBB59_102:                             @   in Loop: Header=BB59_77 Depth=1
	asr	r3, r2, #31
	mov	r0, #1
	str	r0, [sp]
.LBB59_103:                             @   in Loop: Header=BB59_77 Depth=1
	ldr	r1, [sp, #36]           @ 4-byte Reload
	mov	r0, r12
	bl	halide_int64_to_string(PLT)
.LBB59_104:                             @   in Loop: Header=BB59_77 Depth=1
	mov	r12, r0
.LBB59_105:                             @   in Loop: Header=BB59_77 Depth=1
	ldrh	r0, [r6, #14]
	add	r7, r7, #1
	add	r5, r5, #2
	add	r8, r8, #8
	add	r9, r9, #4
	cmp	r7, r0
	blt	.LBB59_77
@ BB#106:
	ldr	r6, [sp, #32]           @ 4-byte Reload
	cmp	r0, #1
	ldr	r9, [sp, #24]           @ 4-byte Reload
	bls	.LBB59_109
@ BB#107:
	ldr	r0, .LCPI59_26
	ldr	r8, [sp, #36]           @ 4-byte Reload
	ldr	r1, .LCPI59_27
.LPC59_12:
	add	r0, pc, r0
	add	r2, r1, r0
	mov	r0, r12
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r12, r0
	b	.LBB59_110
.LBB59_108:
	ldr	r6, [sp, #32]           @ 4-byte Reload
	ldr	r9, [sp, #24]           @ 4-byte Reload
	b	.LBB59_110
.LBB59_109:
	ldr	r8, [sp, #36]           @ 4-byte Reload
.LBB59_110:                             @ %.thread
	ldr	r0, .LCPI59_28
	ldr	r1, .LCPI59_29
.LPC59_13:
	add	r0, pc, r0
	add	r2, r1, r0
	mov	r0, r12
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI59_31
	mov	r1, #1
	ldr	r5, .LCPI59_30
.LPC59_14:
	add	r0, pc, r0
	ldr	r0, [r5, r0]
.LBB59_111:                             @ %._crit_edge.i.9
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB59_112 Depth 2
	dmb	ish
.LBB59_112:                             @ %atomicrmw.start35
                                        @   Parent Loop BB59_111 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrex	r2, [r0]
	strex	r3, r1, [r0]
	cmp	r3, #0
	bne	.LBB59_112
@ BB#113:                               @ %atomicrmw.end34
                                        @   in Loop: Header=BB59_111 Depth=1
	dmb	ish
	cmp	r2, #0
	bne	.LBB59_111
@ BB#114:                               @ %_ZN6Halide7Runtime8Internal14ScopedSpinLockC2EPVi.exit10
	ldr	r0, .LCPI59_32
	cmp	r9, #0
	ldr	r8, .LCPI59_33
	mov	r1, r9
.LPC59_15:
	add	r7, pc, r0
	mov	r0, r6
	addeq	r1, r8, r7
	bl	halide_print(PLT)
	ldr	r0, [r5, r7]
	mov	r1, #0
	dmb	ish
	cmp	r9, #0
	str	r1, [r0]
	bne	.LBB59_116
@ BB#115:
	ldr	r0, .LCPI59_34
.LPC59_16:
	add	r0, pc, r0
	add	r1, r8, r0
	mov	r0, r6
	bl	halide_error(PLT)
.LBB59_116:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi2ELy1024EED2Ev.exit
	mov	r0, r6
	mov	r1, r9
	bl	halide_free(PLT)
.LBB59_117:
	mov	r0, r4
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#118:
.LCPI59_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_0+8)
.LCPI59_1:
	.long	_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE3ids(GOTOFF)
.LCPI59_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_1+8)
.LCPI59_3:
	.long	.L.str.2.41(GOTOFF)
.LCPI59_4:
	.long	.L_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE11event_types(GOTOFF)
.LCPI59_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_2+8)
.LCPI59_6:
	.long	.L.str.13.42(GOTOFF)
.LCPI59_7:
	.long	.L.str.25.136(GOTOFF)
.LCPI59_8:
	.long	.L.str.15.44(GOTOFF)
.LCPI59_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_3+8)
.LCPI59_10:
	.long	.L.str.16.45(GOTOFF)
.LCPI59_11:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_4+8)
.LCPI59_12:
	.long	.L.str.18.47(GOTOFF)
.LCPI59_13:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_5+8)
.LCPI59_14:
	.long	.L.str.17.46(GOTOFF)
.LCPI59_15:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_6+8)
.LCPI59_16:
	.long	.L.str.8.119(GOTOFF)
.LCPI59_17:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_7+8)
.LCPI59_18:
	.long	.L.str.19.48(GOTOFF)
.LCPI59_19:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_8+8)
.LCPI59_20:
	.long	.L.str.22.51(GOTOFF)
.LCPI59_21:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_9+8)
.LCPI59_22:
	.long	.L.str.21.50(GOTOFF)
.LCPI59_23:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_10+8)
.LCPI59_24:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_11+8)
.LCPI59_25:
	.long	.L.str.23.52(GOTOFF)
.LCPI59_26:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_12+8)
.LCPI59_27:
	.long	.L.str.24.53(GOTOFF)
.LCPI59_28:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_13+8)
.LCPI59_29:
	.long	.L.str.25.54(GOTOFF)
.LCPI59_30:
	.long	_ZN6Halide7Runtime8Internal22halide_trace_file_lockE(GOT)
.LCPI59_31:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_14+8)
.LCPI59_32:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_15+8)
.LCPI59_33:
	.long	.L.str.18.149(GOTOFF)
.LCPI59_34:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_16+8)
.LCPI59_35:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_17+8)
.LCPI59_36:
	.long	.L.str.39(GOTOFF)
.LCPI59_37:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_18+8)
.LCPI59_38:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_19+8)
.LCPI59_39:
	.long	.L.str.1.40(GOTOFF)
.LCPI59_40:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC59_20+8)
.Lfunc_end59:
	.size	_ZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_event, .Lfunc_end59-_ZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_event
	.cantunwind
	.fnend

	.section	.text.halide_get_trace_file,"ax",%progbits
	.weak	halide_get_trace_file
	.align	2
	.type	halide_get_trace_file,%function
halide_get_trace_file:                  @ @halide_get_trace_file
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r0
	ldr	r0, .LCPI60_1
	ldr	r6, .LCPI60_0
	mov	r1, #1
.LPC60_0:
	add	r0, pc, r0
	ldr	r0, [r6, r0]
.LBB60_1:                               @ %._crit_edge.i
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB60_2 Depth 2
	dmb	ish
.LBB60_2:                               @ %atomicrmw.start
                                        @   Parent Loop BB60_1 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrex	r2, [r0]
	strex	r3, r1, [r0]
	cmp	r3, #0
	bne	.LBB60_2
@ BB#3:                                 @ %atomicrmw.end
                                        @   in Loop: Header=BB60_1 Depth=1
	dmb	ish
	cmp	r2, #0
	bne	.LBB60_1
@ BB#4:                                 @ %_ZN6Halide7Runtime8Internal14ScopedSpinLockC2EPVi.exit
	ldr	r1, .LCPI60_3
	ldr	r0, .LCPI60_2
.LPC60_1:
	add	r1, pc, r1
	ldr	r0, [r0, r1]
	ldrb	r0, [r0]
	cmp	r0, #0
	bne	.LBB60_10
@ BB#5:
	ldr	r0, .LCPI60_4
	ldr	r1, .LCPI60_5
.LPC60_2:
	add	r0, pc, r0
	add	r0, r1, r0
	bl	getenv(PLT)
	cmp	r0, #0
	beq	.LBB60_9
@ BB#6:
	movw	r1, #1089
	mov	r2, #420
	bl	open(PLT)
	mov	r5, r0
	cmp	r5, #0
	bgt	.LBB60_8
@ BB#7:
	ldr	r0, .LCPI60_6
	ldr	r1, .LCPI60_7
.LPC60_3:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r4
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB60_8:
	mov	r0, r5
	bl	halide_set_trace_file(PLT)
	ldr	r1, .LCPI60_9
	ldr	r0, .LCPI60_8
.LPC60_4:
	add	r1, pc, r1
	ldr	r0, [r0, r1]
	mov	r1, #1
	strb	r1, [r0]
	b	.LBB60_10
.LBB60_9:
	mov	r0, #0
	bl	halide_set_trace_file(PLT)
.LBB60_10:
	ldr	r1, .LCPI60_11
	mov	r2, #0
	ldr	r0, .LCPI60_10
.LPC60_5:
	add	r1, pc, r1
	ldr	r0, [r0, r1]
	ldr	r1, [r6, r1]
	ldr	r0, [r0]
	dmb	ish
	str	r2, [r1]
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#11:
.LCPI60_0:
	.long	_ZN6Halide7Runtime8Internal22halide_trace_file_lockE(GOT)
.LCPI60_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC60_0+8)
.LCPI60_2:
	.long	_ZN6Halide7Runtime8Internal29halide_trace_file_initializedE(GOT)
.LCPI60_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC60_1+8)
.LCPI60_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC60_2+8)
.LCPI60_5:
	.long	.L.str.26.56(GOTOFF)
.LCPI60_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC60_3+8)
.LCPI60_7:
	.long	.L.str.27.57(GOTOFF)
.LCPI60_8:
	.long	_ZN6Halide7Runtime8Internal35halide_trace_file_internally_openedE(GOT)
.LCPI60_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC60_4+8)
.LCPI60_10:
	.long	_ZN6Halide7Runtime8Internal17halide_trace_fileE(GOT)
.LCPI60_11:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC60_5+8)
.Lfunc_end60:
	.size	halide_get_trace_file, .Lfunc_end60-halide_get_trace_file
	.cantunwind
	.fnend

	.section	.text.halide_set_custom_trace,"ax",%progbits
	.weak	halide_set_custom_trace
	.align	2
	.type	halide_set_custom_trace,%function
halide_set_custom_trace:                @ @halide_set_custom_trace
	.fnstart
@ BB#0:
	ldr	r2, .LCPI61_1
	ldr	r1, .LCPI61_0
.LPC61_0:
	add	r2, pc, r2
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	str	r0, [r2]
	mov	r0, r1
	bx	lr
	.align	2
@ BB#1:
.LCPI61_0:
	.long	_ZN6Halide7Runtime8Internal19halide_custom_traceE(GOT)
.LCPI61_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC61_0+8)
.Lfunc_end61:
	.size	halide_set_custom_trace, .Lfunc_end61-halide_set_custom_trace
	.cantunwind
	.fnend

	.section	.text.halide_set_trace_file,"ax",%progbits
	.weak	halide_set_trace_file
	.align	2
	.type	halide_set_trace_file,%function
halide_set_trace_file:                  @ @halide_set_trace_file
	.fnstart
@ BB#0:
	ldr	r2, .LCPI62_1
	ldr	r1, .LCPI62_0
	ldr	r3, .LCPI62_2
.LPC62_0:
	add	r2, pc, r2
	ldr	r1, [r1, r2]
	ldr	r2, [r3, r2]
	str	r0, [r1]
	mov	r0, #1
	strb	r0, [r2]
	bx	lr
	.align	2
@ BB#1:
.LCPI62_0:
	.long	_ZN6Halide7Runtime8Internal17halide_trace_fileE(GOT)
.LCPI62_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC62_0+8)
.LCPI62_2:
	.long	_ZN6Halide7Runtime8Internal29halide_trace_file_initializedE(GOT)
.Lfunc_end62:
	.size	halide_set_trace_file, .Lfunc_end62-halide_set_trace_file
	.cantunwind
	.fnend

	.section	.text.halide_trace,"ax",%progbits
	.weak	halide_trace
	.align	2
	.type	halide_trace,%function
halide_trace:                           @ @halide_trace
	.fnstart
@ BB#0:
	ldr	r3, .LCPI63_1
	ldr	r2, .LCPI63_0
.LPC63_0:
	add	r3, pc, r3
	ldr	r2, [r2, r3]
	ldr	r2, [r2]
	bx	r2
	.align	2
@ BB#1:
.LCPI63_0:
	.long	_ZN6Halide7Runtime8Internal19halide_custom_traceE(GOT)
.LCPI63_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC63_0+8)
.Lfunc_end63:
	.size	halide_trace, .Lfunc_end63-halide_trace
	.cantunwind
	.fnend

	.section	.text.halide_shutdown_trace,"ax",%progbits
	.weak	halide_shutdown_trace
	.align	2
	.type	halide_shutdown_trace,%function
halide_shutdown_trace:                  @ @halide_shutdown_trace
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	ldr	r0, .LCPI64_1
	ldr	r4, .LCPI64_0
.LPC64_0:
	add	r0, pc, r0
	ldr	r0, [r4, r0]
	ldrb	r0, [r0]
	cmp	r0, #0
	beq	.LBB64_2
@ BB#1:
	ldr	r1, .LCPI64_3
	ldr	r0, .LCPI64_2
.LPC64_1:
	add	r5, pc, r1
	ldr	r6, [r0, r5]
	ldr	r0, [r6]
	bl	close(PLT)
	ldr	r1, .LCPI64_4
	mov	r3, #0
	ldr	r2, [r4, r5]
	str	r3, [r6]
	ldr	r1, [r1, r5]
	strb	r3, [r2]
	strb	r3, [r1]
	pop	{r4, r5, r6, r10, r11, pc}
.LBB64_2:
	mov	r0, #0
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#3:
.LCPI64_0:
	.long	_ZN6Halide7Runtime8Internal35halide_trace_file_internally_openedE(GOT)
.LCPI64_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC64_0+8)
.LCPI64_2:
	.long	_ZN6Halide7Runtime8Internal17halide_trace_fileE(GOT)
.LCPI64_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC64_1+8)
.LCPI64_4:
	.long	_ZN6Halide7Runtime8Internal29halide_trace_file_initializedE(GOT)
.Lfunc_end64:
	.size	halide_shutdown_trace, .Lfunc_end64-halide_shutdown_trace
	.cantunwind
	.fnend

	.section	.text.halide_trace_cleanup,"ax",%progbits
	.weak	halide_trace_cleanup
	.align	2
	.type	halide_trace_cleanup,%function
halide_trace_cleanup:                   @ @halide_trace_cleanup
	.fnstart
@ BB#0:
	b	halide_shutdown_trace(PLT)
.Lfunc_end65:
	.size	halide_trace_cleanup, .Lfunc_end65-halide_trace_cleanup
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal18has_tiff_extensionEPKc,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal18has_tiff_extensionEPKc
	.align	2
	.type	_ZN6Halide7Runtime8Internal18has_tiff_extensionEPKc,%function
_ZN6Halide7Runtime8Internal18has_tiff_extensionEPKc: @ @_ZN6Halide7Runtime8Internal18has_tiff_extensionEPKc
	.fnstart
@ BB#0:
	mov	r1, r0
.LBB66_1:                               @ =>This Inner Loop Header: Depth=1
	mov	r2, r1
	ldrb	r3, [r1], #1
	cmp	r3, #0
	bne	.LBB66_1
@ BB#2:                                 @ %.preheader
	mov	r1, #0
	cmp	r2, r0
	beq	.LBB66_14
.LBB66_3:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	tst	r1, #1
	bne	.LBB66_6
@ BB#4:                                 @   in Loop: Header=BB66_3 Depth=1
	ldrb	r3, [r2, #-1]!
	mov	r1, #0
	cmp	r3, #46
	movweq	r1, #1
	cmp	r0, r2
	bne	.LBB66_3
@ BB#5:                                 @ %.critedge
	mov	r1, #0
	cmp	r3, #46
	bne	.LBB66_14
	b	.LBB66_7
.LBB66_6:
	mov	r0, r2
.LBB66_7:                               @ %.critedge.thread
	ldrb	r1, [r0, #1]
	orr	r1, r1, #32
	uxtb	r2, r1
	mov	r1, #0
	cmp	r2, #116
	bne	.LBB66_14
@ BB#8:
	ldrb	r2, [r0, #2]
	orr	r2, r2, #32
	uxtb	r2, r2
	cmp	r2, #105
	bne	.LBB66_14
@ BB#9:
	ldrb	r2, [r0, #3]
	orr	r2, r2, #32
	uxtb	r2, r2
	cmp	r2, #102
	bne	.LBB66_14
@ BB#10:
	ldrb	r2, [r0, #4]
	mov	r1, #1
	cmp	r2, #0
	beq	.LBB66_14
@ BB#11:
	cmp	r2, #70
	beq	.LBB66_13
@ BB#12:
	cmp	r2, #102
	bne	.LBB66_15
.LBB66_13:
	ldrb	r0, [r0, #5]
	mov	r1, #0
	cmp	r0, #0
	movweq	r1, #1
.LBB66_14:                              @ %.critedge.thread10
	mov	r0, r1
	bx	lr
.LBB66_15:
	mov	r1, #0
	mov	r0, r1
	bx	lr
.Lfunc_end66:
	.size	_ZN6Halide7Runtime8Internal18has_tiff_extensionEPKc, .Lfunc_end66-_ZN6Halide7Runtime8Internal18has_tiff_extensionEPKc
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal19get_pointer_to_dataEiiiiPK8buffer_t,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal19get_pointer_to_dataEiiiiPK8buffer_t
	.align	2
	.type	_ZN6Halide7Runtime8Internal19get_pointer_to_dataEiiiiPK8buffer_t,%function
_ZN6Halide7Runtime8Internal19get_pointer_to_dataEiiiiPK8buffer_t: @ @_ZN6Halide7Runtime8Internal19get_pointer_to_dataEiiiiPK8buffer_t
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r11, lr}
	push	{r4, r5, r6, r7, r11, lr}
	ldr	r12, [sp, #24]
	add	r6, r12, #32
	ldr	lr, [r12, #8]
	ldm	r6, {r4, r5, r6}
	ldr	r7, [r12, #28]
	mul	r0, r7, r0
	mla	r0, r4, r1, r0
	ldr	r1, [r12, #60]
	mla	r0, r5, r2, r0
	mla	r0, r6, r3, r0
	mla	r0, r0, r1, lr
	pop	{r4, r5, r6, r7, r11, pc}
.Lfunc_end67:
	.size	_ZN6Halide7Runtime8Internal19get_pointer_to_dataEiiiiPK8buffer_t, .Lfunc_end67-_ZN6Halide7Runtime8Internal19get_pointer_to_dataEiiiiPK8buffer_t
	.cantunwind
	.fnend

	.section	.text.halide_debug_to_file,"ax",%progbits
	.weak	halide_debug_to_file
	.align	4
	.type	halide_debug_to_file,%function
halide_debug_to_file:                   @ @halide_debug_to_file
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#68
	sub	sp, sp, #68
	.pad	#4096
	sub	sp, sp, #4096
	mov	r6, r3
	mov	r4, r1
	mov	r1, r6
	mov	r5, r2
	bl	halide_copy_to_host(PLT)
	ldr	r0, .LCPI68_0
	ldr	r1, .LCPI68_1
.LPC68_0:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r4
	bl	fopen(PLT)
	mov	r1, r0
	mvn	r0, #0
	cmp	r1, #0
	beq	.LBB68_35
@ BB#1:
	str	r5, [sp, #48]           @ 4-byte Spill
	ldr	r5, [r6, #20]
	ldr	r8, [r6, #24]
	ldr	r0, [r6, #60]
	cmp	r8, #1
	ldr	r7, [r6, #16]
	movwlt	r8, #1
	ldr	r10, [r6, #12]
	cmp	r5, #1
	mov	r9, r5
	movwlt	r9, #1
	cmp	r7, #1
	movwlt	r7, #1
	cmp	r10, #1
	str	r0, [sp, #52]           @ 4-byte Spill
	mov	r0, r4
	str	r1, [sp, #40]           @ 4-byte Spill
	movwlt	r10, #1
	str	r6, [sp, #28]           @ 4-byte Spill
	str	r7, [sp, #32]           @ 4-byte Spill
	bl	_ZN6Halide7Runtime8Internal18has_tiff_extensionEPKc(PLT)
	cmp	r0, #1
	bne	.LBB68_12
@ BB#2:
	movw	r1, #18761
	ldr	r0, [sp, #52]           @ 4-byte Reload
	strh	r1, [sp, #56]
	mov	r1, #42
	mov	lr, #4
	movw	r3, #257
	strh	r1, [sp, #58]
	mov	r1, #8
	cmp	r8, #2
	mov	r4, #0
	str	r1, [sp, #60]
	mov	r1, #15
	strh	r1, [sp, #64]
	mov	r1, #256
	movwlo	r4, #1
	cmp	r9, #5
	strh	r1, [sp, #66]
	mov	r1, #1
	movw	r2, #277
	add	r12, sp, #186
	str	r5, [sp, #20]           @ 4-byte Spill
	lsl	r5, r0, #3
	strh	lr, [sp, #68]
	str	r1, [sp, #70]
	str	r10, [sp, #74]
	strh	r3, [sp, #78]
	movw	r3, #258
	strh	lr, [sp, #80]
	str	r1, [sp, #82]
	str	r7, [sp, #86]
	strh	r3, [sp, #90]
	mov	r3, #3
	strh	r3, [sp, #92]
	str	r1, [sp, #94]
	strh	r5, [sp, #98]
	movw	r5, #259
	strh	r5, [sp, #102]
	movw	r5, #262
	strh	r3, [sp, #104]
	str	r1, [sp, #106]
	strh	r1, [sp, #110]
	strh	r5, [sp, #114]
	mov	r5, #0
	movwlt	r5, #1
	ands	r6, r5, r4
	mov	r5, r8
	movne	r5, r9
	mov	r4, #1
	cmp	r5, #2
	strh	r3, [sp, #116]
	movwgt	r4, #2
	cmp	r5, #1
	str	r1, [sp, #118]
	strh	r4, [sp, #122]
	movw	r4, #273
	strh	r4, [sp, #126]
	mov	r4, #210
	strh	lr, [sp, #128]
	str	r5, [sp, #130]
	str	r4, [sp, #134]
	add	r4, r4, r5, lsl #2
	strh	r2, [sp, #138]
	movw	r2, #278
	strh	r3, [sp, #140]
	str	r1, [sp, #142]
	strh	r5, [sp, #146]
	strh	r2, [sp, #150]
	movw	r2, #279
	strh	lr, [sp, #152]
	str	r1, [sp, #154]
	str	r7, [sp, #158]
	mul	r7, r7, r10
	strh	r2, [sp, #162]
	strh	lr, [sp, #164]
	mul	r2, r7, r9
	str	r5, [sp, #166]
	str	r10, [sp, #24]          @ 4-byte Spill
	mov	r10, r9
	mul	r2, r2, r0
	add	r0, sp, #56
	muleq	r4, r2, r8
	movw	r2, #282
	cmp	r6, #0
	movwne	r10, #1
	str	r4, [sp, #170]
	mov	r4, #194
	strh	r2, [sp, #174]
	mov	r2, #5
	strh	r2, [sp, #176]
	str	r1, [sp, #178]
	str	r4, [sp, #182]
	movw	r4, #283
	strh	r4, [r12]
	strh	r2, [r12, #2]
	mov	r2, #202
	str	r1, [sp, #190]
	str	r2, [sp, #194]
	mov	r2, #284
	strh	r2, [r12, #12]
	mov	r2, #2
	strh	r3, [r12, #14]
	str	r1, [sp, #202]
	strh	r2, [r12, #20]
	mov	r2, #296
	strh	r2, [r12, #24]
	ldr	r2, .LCPI68_2
	ldr	r4, .LCPI68_3
.LPC68_1:
	add	r2, pc, r2
	strh	r3, [r12, #26]
	ldr	r2, [r4, r2]
	ldr	r4, [sp, #48]           @ 4-byte Reload
	str	r1, [sp, #214]
	strh	r1, [r12, #32]
	add	r2, r2, r4, lsl #1
	movw	r4, #339
	strh	r4, [r12, #36]
	ldrh	r2, [r2]
	adr	r4, .LCPI68_4
	vld1.64	{d16, d17}, [r4:128]
	ldr	r4, [sp, #40]           @ 4-byte Reload
	strh	r3, [r12, #38]
	str	r1, [sp, #226]
	mov	r3, r4
	strh	r2, [r12, #44]
	movw	r2, #32997
	strh	r2, [r12, #48]
	add	r2, r0, #190
	strh	lr, [r12, #50]
	str	r1, [sp, #238]
	str	r10, [sp, #242]
	vst1.16	{d16, d17}, [r2]
	mov	r2, #1
	str	r1, [sp, #262]
	mov	r1, #210
	str	r9, [sp, #16]           @ 4-byte Spill
	bl	fwrite(PLT)
	cmp	r0, #0
	beq	.LBB68_38
@ BB#3:
	cmp	r5, #2
	blt	.LBB68_11
@ BB#4:                                 @ %.lr.ph112
	ldr	r0, [sp, #52]           @ 4-byte Reload
	mov	r1, #210
	mov	r6, r4
	add	r1, r1, r5, lsl #3
	str	r8, [sp, #12]           @ 4-byte Spill
	mov	r8, r7
	mul	r0, r7, r0
	mov	r7, #0
	str	r1, [r11, #-36]
	sub	r9, r11, #36
	mul	r4, r0, r10
.LBB68_5:                               @ =>This Inner Loop Header: Depth=1
	mov	r0, r9
	mov	r1, #4
	mov	r2, #1
	mov	r3, r6
	bl	fwrite(PLT)
	cmp	r0, #0
	beq	.LBB68_40
@ BB#6:                                 @   in Loop: Header=BB68_5 Depth=1
	ldr	r0, [r11, #-36]
	add	r7, r7, #1
	cmp	r7, r5
	add	r0, r0, r4
	str	r0, [r11, #-36]
	blt	.LBB68_5
@ BB#7:                                 @ %.lr.ph108
	mul	r0, r10, r8
	mov	r7, #0
	sub	r4, r11, #40
	str	r0, [r11, #-40]
.LBB68_8:                               @ =>This Inner Loop Header: Depth=1
	mov	r0, r4
	mov	r1, #4
	mov	r2, #1
	mov	r3, r6
	bl	fwrite(PLT)
	cmp	r0, #0
	beq	.LBB68_40
@ BB#9:                                 @   in Loop: Header=BB68_8 Depth=1
	add	r7, r7, #1
	cmp	r7, r5
	blt	.LBB68_8
@ BB#10:                                @ %._crit_edge.109
	ldr	r8, [sp, #12]           @ 4-byte Reload
	mov	r4, r6
.LBB68_11:                              @ %.thread42
	mov	r7, r8
	ldr	r1, [sp, #52]           @ 4-byte Reload
	ldr	r5, [sp, #20]           @ 4-byte Reload
	mov	r10, r4
	ldr	r9, [sp, #16]           @ 4-byte Reload
	b	.LBB68_14
.LBB68_12:
	str	r10, [sp, #56]
	mov	r1, #20
	str	r10, [sp, #24]          @ 4-byte Spill
	mov	r2, #1
	ldr	r10, [sp, #40]          @ 4-byte Reload
	ldr	r0, [sp, #48]           @ 4-byte Reload
	str	r7, [sp, #60]
	str	r9, [sp, #64]
	mov	r3, r10
	str	r8, [sp, #68]
	str	r0, [sp, #72]
	add	r0, sp, #56
	ldr	r4, [sp, #52]           @ 4-byte Reload
	bl	fwrite(PLT)
	cmp	r0, #0
	beq	.LBB68_39
@ BB#13:
	mov	r7, r8
	mov	r1, r4
.LBB68_14:
	mov	r0, #4096
	mov	r8, r1
	bl	__aeabi_idiv(PLT)
	mov	r12, r7
	cmp	r12, #1
	blt	.LBB68_34
@ BB#15:                                @ %.preheader70.lr.ph
	mul	r2, r0, r8
	mov	r1, #1
	cmp	r5, #1
	ldr	r6, [sp, #28]           @ 4-byte Reload
	movle	r5, r1
	str	r0, [sp, #44]           @ 4-byte Spill
	mov	r3, r5
	str	r5, [sp, #20]           @ 4-byte Spill
	ldr	r5, [sp, #24]           @ 4-byte Reload
	bfc	r3, #0, #4
	str	r2, [sp, #36]           @ 4-byte Spill
	mov	r0, #0
	add	r2, sp, #56
	mov	r4, #0
	mov	r7, r8
	str	r3, [sp, #8]            @ 4-byte Spill
	str	r0, [sp, #52]           @ 4-byte Spill
.LBB68_16:                              @ %.preheader.lr.ph.us.preheader
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB68_27 Depth 2
                                        @     Child Loop BB68_30 Depth 2
                                        @     Child Loop BB68_18 Depth 2
                                        @       Child Loop BB68_19 Depth 3
                                        @         Child Loop BB68_20 Depth 4
	mov	r0, #0
	cmp	r5, #0
	ble	.LBB68_25
@ BB#17:                                @   in Loop: Header=BB68_16 Depth=1
	str	r0, [sp, #48]           @ 4-byte Spill
.LBB68_18:                              @ %.lr.ph.us.us.preheader.us
                                        @   Parent Loop BB68_16 Depth=1
                                        @ =>  This Loop Header: Depth=2
                                        @       Child Loop BB68_19 Depth 3
                                        @         Child Loop BB68_20 Depth 4
	str	r9, [sp, #16]           @ 4-byte Spill
	mov	r8, r2
	str	r12, [sp, #12]          @ 4-byte Spill
	mov	r9, #0
	str	r10, [sp, #40]          @ 4-byte Spill
.LBB68_19:                              @ %.lr.ph.us.us.us
                                        @   Parent Loop BB68_16 Depth=1
                                        @     Parent Loop BB68_18 Depth=2
                                        @ =>    This Loop Header: Depth=3
                                        @         Child Loop BB68_20 Depth 4
	mov	r10, #0
.LBB68_20:                              @   Parent Loop BB68_16 Depth=1
                                        @     Parent Loop BB68_18 Depth=2
                                        @       Parent Loop BB68_19 Depth=3
                                        @ =>      This Inner Loop Header: Depth=4
	ldr	r2, [sp, #48]           @ 4-byte Reload
	mov	r0, r10
	ldr	r3, [sp, #52]           @ 4-byte Reload
	mov	r1, r9
	str	r6, [sp]
	bl	_ZN6Halide7Runtime8Internal19get_pointer_to_dataEiiiiPK8buffer_t(PLT)
	mov	r1, r0
	mla	r0, r4, r7, r8
	mov	r2, r7
	bl	memcpy(PLT)
	ldr	r0, [sp, #44]           @ 4-byte Reload
	add	r4, r4, #1
	cmp	r4, r0
	bne	.LBB68_22
@ BB#21:                                @   in Loop: Header=BB68_20 Depth=4
	ldr	r1, [sp, #36]           @ 4-byte Reload
	mov	r0, r8
	ldr	r3, [sp, #40]           @ 4-byte Reload
	mov	r2, #1
	bl	fwrite(PLT)
	mov	r4, #0
	cmp	r0, #0
	beq	.LBB68_36
.LBB68_22:                              @   in Loop: Header=BB68_20 Depth=4
	add	r10, r10, #1
	cmp	r10, r5
	blt	.LBB68_20
@ BB#23:                                @   in Loop: Header=BB68_19 Depth=3
	ldr	r0, [sp, #32]           @ 4-byte Reload
	add	r9, r9, #1
	cmp	r9, r0
	blt	.LBB68_19
@ BB#24:                                @ %._crit_edge.79.us-lcssa.us98.us
                                        @   in Loop: Header=BB68_18 Depth=2
	ldr	r0, [sp, #48]           @ 4-byte Reload
	mov	r2, r8
	ldr	r9, [sp, #16]           @ 4-byte Reload
	ldr	r10, [sp, #40]          @ 4-byte Reload
	add	r0, r0, #1
	ldr	r12, [sp, #12]          @ 4-byte Reload
	cmp	r0, r9
	ldr	r3, [sp, #8]            @ 4-byte Reload
	str	r0, [sp, #48]           @ 4-byte Spill
	blt	.LBB68_18
	b	.LBB68_31
.LBB68_25:                              @ %overflow.checked.preheader
                                        @   in Loop: Header=BB68_16 Depth=1
	ldr	r1, [sp, #20]           @ 4-byte Reload
	cmp	r1, #0
	beq	.LBB68_30
@ BB#26:                                @ %overflow.checked43
                                        @   in Loop: Header=BB68_16 Depth=1
	mov	r0, #0
	mov	r1, r3
	cmp	r3, #0
	beq	.LBB68_29
.LBB68_27:                              @ %vector.body
                                        @   Parent Loop BB68_16 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	subs	r1, r1, #16
	bne	.LBB68_27
@ BB#28:                                @   in Loop: Header=BB68_16 Depth=1
	mov	r0, r3
.LBB68_29:                              @ %middle.block
                                        @   in Loop: Header=BB68_16 Depth=1
	ldr	r1, [sp, #20]           @ 4-byte Reload
	cmp	r1, r0
	beq	.LBB68_31
.LBB68_30:                              @ %overflow.checked
                                        @   Parent Loop BB68_16 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	add	r0, r0, #1
	cmp	r0, r9
	blt	.LBB68_30
.LBB68_31:                              @ %._crit_edge.85
                                        @   in Loop: Header=BB68_16 Depth=1
	ldr	r0, [sp, #52]           @ 4-byte Reload
	add	r0, r0, #1
	str	r0, [sp, #52]           @ 4-byte Spill
	cmp	r0, r12
	blt	.LBB68_16
@ BB#32:                                @ %._crit_edge.104
	cmp	r4, #1
	blt	.LBB68_34
@ BB#33:
	mul	r1, r4, r7
	add	r0, sp, #56
	mov	r2, #1
	mov	r3, r10
	bl	fwrite(PLT)
	cmp	r0, #0
	beq	.LBB68_42
.LBB68_34:                              @ %._crit_edge.104.thread
	mov	r0, r10
	bl	fclose(PLT)
	mov	r0, #0
.LBB68_35:
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB68_36:                              @ %.us-lcssa.us
	ldr	r0, [sp, #40]           @ 4-byte Reload
.LBB68_37:
	bl	fclose(PLT)
	mvn	r0, #0
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB68_38:
	mov	r0, r4
	b	.LBB68_41
.LBB68_39:                              @ %.critedge
	mov	r0, r10
	b	.LBB68_41
.LBB68_40:
	mov	r0, r6
.LBB68_41:                              @ %.thread45
	bl	fclose(PLT)
	mvn	r0, #1
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB68_42:
	mov	r0, r10
	b	.LBB68_37
	.align	4
@ BB#43:
.LCPI68_4:
	.long	0                       @ 0x0
	.long	1                       @ 0x1
	.long	1                       @ 0x1
	.long	1                       @ 0x1
.LCPI68_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC68_0+8)
.LCPI68_1:
	.long	.L.str.68(GOTOFF)
.LCPI68_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC68_1+8)
.LCPI68_3:
	.long	_ZN6Halide7Runtime8Internal30pixel_type_to_tiff_sample_typeE(GOT)
.Lfunc_end68:
	.size	halide_debug_to_file, .Lfunc_end68-halide_debug_to_file
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t
	.align	2
	.type	_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t,%function
_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t: @ @_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, lr}
	push	{r4, r5, r6, lr}
	mov	r1, r0
	ldr	r5, [r1, #12]
	ldr	r0, [r1, #60]
	ldr	r2, [r1, #16]
	ldr	r3, [r1, #28]
	mul	r5, r5, r0
	ldr	lr, [r1, #20]
	cmp	r3, #0
	ldr	r4, [r1, #32]
	mul	r2, r2, r0
	ldr	r12, [r1, #24]
	rsbmi	r3, r3, #0
	ldr	r6, [r1, #36]
	cmp	r4, #0
	mul	lr, lr, r0
	rsbmi	r4, r4, #0
	ldr	r1, [r1, #40]
	mul	r5, r5, r3
	cmp	r6, #0
	rsbmi	r6, r6, #0
	mul	r3, r2, r4
	cmp	r1, #0
	rsbmi	r1, r1, #0
	mul	r12, r12, r0
	cmp	r5, r0
	movhi	r0, r5
	mul	r2, lr, r6
	cmp	r3, r0
	movhi	r0, r3
	mul	r1, r12, r1
	cmp	r2, r0
	movhi	r0, r2
	cmp	r1, r0
	movhi	r0, r1
	pop	{r4, r5, r6, pc}
.Lfunc_end69:
	.size	_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t, .Lfunc_end69-_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j
	.align	2
	.type	_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j,%function
_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j: @ @_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	.setfp	r11, sp
	mov	r11, sp
	bl	memcmp(PLT)
	mov	r1, #0
	cmp	r0, #0
	movweq	r1, #1
	mov	r0, r1
	pop	{r11, pc}
.Lfunc_end70:
	.size	_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j, .Lfunc_end70-_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_
	.align	2
	.type	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_,%function
_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_: @ @_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_
	.fnstart
@ BB#0:
	ldr	r2, [r1, #60]
	ldr	r3, [r0, #60]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#1:                                 @ %.preheader
	ldr	r2, [r1, #44]
	ldr	r3, [r0, #44]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#2:
	ldr	r2, [r1, #12]
	ldr	r3, [r0, #12]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#3:
	ldr	r2, [r1, #28]
	ldr	r3, [r0, #28]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#4:
	ldr	r2, [r1, #48]
	ldr	r3, [r0, #48]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#5:
	ldr	r2, [r1, #16]
	ldr	r3, [r0, #16]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#6:
	ldr	r2, [r1, #32]
	ldr	r3, [r0, #32]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#7:
	ldr	r2, [r1, #52]
	ldr	r3, [r0, #52]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#8:
	ldr	r2, [r1, #20]
	ldr	r3, [r0, #20]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#9:
	ldr	r2, [r1, #36]
	ldr	r3, [r0, #36]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#10:
	ldr	r2, [r1, #56]
	ldr	r3, [r0, #56]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#11:
	ldr	r2, [r1, #24]
	ldr	r3, [r0, #24]
	cmp	r3, r2
	bne	.LBB71_13
@ BB#12:
	ldr	r2, [r0, #40]
	mov	r0, #0
	ldr	r1, [r1, #40]
	cmp	r2, r1
	movweq	r0, #1
	bx	lr
.LBB71_13:                              @ %.loopexit
	mov	r0, #0
	bx	lr
.Lfunc_end71:
	.size	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_, .Lfunc_end71-_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh
	.align	2
	.type	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh,%function
_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh: @ @_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh
	.fnstart
@ BB#0:
	sub	r0, r0, #16
	bx	lr
.Lfunc_end72:
	.size	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh, .Lfunc_end72-_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal10CacheEntry4initEPKhjjRK8buffer_tiPPS5_,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal10CacheEntry4initEPKhjjRK8buffer_tiPPS5_
	.align	2
	.type	_ZN6Halide7Runtime8Internal10CacheEntry4initEPKhjjRK8buffer_tiPPS5_,%function
_ZN6Halide7Runtime8Internal10CacheEntry4initEPKhjjRK8buffer_tiPPS5_: @ @_ZN6Halide7Runtime8Internal10CacheEntry4initEPKhjjRK8buffer_tiPPS5_
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	mov	r4, r0
	ldr	r0, [r11, #12]
	mov	r7, #0
	mov	r6, r1
	str	r7, [r4]
	mov	r1, r2
	str	r7, [r4, #4]
	str	r7, [r4, #8]
	str	r2, [r4, #12]
	str	r3, [r4, #20]
	str	r7, [r4, #24]
	str	r0, [r4, #28]
	mov	r0, #0
	bl	halide_malloc(PLT)
	mov	r8, r0
	str	r8, [r4, #16]
	cmp	r8, #0
	beq	.LBB73_8
@ BB#1:
	ldr	r1, [r11, #8]
	add	r0, r4, #32
	mov	r2, #72
	bl	__aeabi_memcpy8(PLT)
	mov	r5, #0
	str	r5, [r4, #32]
	str	r5, [r4, #36]
	str	r5, [r4, #40]
	ldr	r0, [r4, #12]
	cmp	r0, #0
	beq	.LBB73_5
@ BB#2:                                 @ %.lr.ph4.preheader
	ldrb	r0, [r6]
	strb	r0, [r8]
	ldr	r0, [r4, #12]
	cmp	r0, #1
	bls	.LBB73_5
@ BB#3:
	mov	r0, #1
.LBB73_4:                               @ %._crit_edge
                                        @ =>This Inner Loop Header: Depth=1
	ldrb	r1, [r6, r0]
	ldr	r2, [r4, #16]
	strb	r1, [r2, r0]
	add	r0, r0, #1
	ldr	r1, [r4, #12]
	cmp	r0, r1
	blo	.LBB73_4
.LBB73_5:                               @ %.preheader
	ldr	r0, [r4, #28]
	mov	r7, #1
	cmp	r0, #0
	beq	.LBB73_8
@ BB#6:
	ldr	r6, [r11, #16]
.LBB73_7:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	mov	r0, r4
	mov	r1, r5
	bl	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi(PLT)
	ldr	r1, [r6], #4
	mov	r2, #72
	bl	__aeabi_memcpy8(PLT)
	ldr	r0, [r4, #28]
	add	r5, r5, #1
	cmp	r5, r0
	blo	.LBB73_7
.LBB73_8:                               @ %.loopexit
	mov	r0, r7
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
.Lfunc_end73:
	.size	_ZN6Halide7Runtime8Internal10CacheEntry4initEPKhjjRK8buffer_tiPPS5_, .Lfunc_end73-_ZN6Halide7Runtime8Internal10CacheEntry4initEPKhjjRK8buffer_tiPPS5_
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal10CacheEntry6bufferEi,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi
	.align	2
	.type	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi,%function
_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi: @ @_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi
	.fnstart
@ BB#0:
	add	r1, r1, r1, lsl #3
	add	r0, r0, r1, lsl #3
	add	r0, r0, #104
	bx	lr
.Lfunc_end74:
	.size	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi, .Lfunc_end74-_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal10CacheEntry7destroyEv,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal10CacheEntry7destroyEv
	.align	2
	.type	_ZN6Halide7Runtime8Internal10CacheEntry7destroyEv,%function
_ZN6Halide7Runtime8Internal10CacheEntry7destroyEv: @ @_ZN6Halide7Runtime8Internal10CacheEntry7destroyEv
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	mov	r0, #0
	ldr	r1, [r4, #16]
	mov	r5, #0
	bl	halide_free(PLT)
	ldr	r0, [r4, #28]
	cmp	r0, #0
	beq	.LBB75_2
.LBB75_1:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	mov	r0, r4
	mov	r1, r5
	bl	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi(PLT)
	mov	r1, r0
	mov	r0, #0
	bl	halide_device_free(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi(PLT)
	ldr	r0, [r0, #8]
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	mov	r1, r0
	mov	r0, #0
	bl	halide_free(PLT)
	ldr	r0, [r4, #28]
	add	r5, r5, #1
	cmp	r5, r0
	blo	.LBB75_1
.LBB75_2:                               @ %._crit_edge
	pop	{r4, r5, r11, pc}
.Lfunc_end75:
	.size	_ZN6Halide7Runtime8Internal10CacheEntry7destroyEv, .Lfunc_end75-_ZN6Halide7Runtime8Internal10CacheEntry7destroyEv
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal8djb_hashEPKhj,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal8djb_hashEPKhj
	.align	2
	.type	_ZN6Halide7Runtime8Internal8djb_hashEPKhj,%function
_ZN6Halide7Runtime8Internal8djb_hashEPKhj: @ @_ZN6Halide7Runtime8Internal8djb_hashEPKhj
	.fnstart
@ BB#0:
	mov	r2, r0
	movw	r0, #5381
	cmp	r1, #0
	bxeq	lr
.LBB76_1:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	add	r0, r0, r0, lsl #5
	ldrb	r3, [r2], #1
	subs	r1, r1, #1
	add	r0, r3, r0
	bne	.LBB76_1
@ BB#2:                                 @ %._crit_edge
	bx	lr
.Lfunc_end76:
	.size	_ZN6Halide7Runtime8Internal8djb_hashEPKhj, .Lfunc_end76-_ZN6Halide7Runtime8Internal8djb_hashEPKhj
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal11prune_cacheEv,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal11prune_cacheEv
	.align	2
	.type	_ZN6Halide7Runtime8Internal11prune_cacheEv,%function
_ZN6Halide7Runtime8Internal11prune_cacheEv: @ @_ZN6Halide7Runtime8Internal11prune_cacheEv
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#20
	sub	sp, sp, #20
	ldr	r0, .LCPI77_1
	ldr	r6, .LCPI77_3
.LPC77_0:
	add	r0, pc, r0
	ldr	r1, [r6, r0]
	ldr	r4, [r1]
	cmp	r4, #0
	beq	.LBB77_18
@ BB#1:
	ldr	r12, .LCPI77_0
	mov	r7, #0
	ldr	lr, .LCPI77_2
	mov	r5, #0
	ldr	r1, [r12, r0]
	ldr	r2, [lr, r0]
	ldrd	r0, r1, [r1]
	ldrd	r2, r3, [r2]
	cmp	r2, r0
	movwls	r7, #1
	cmp	r3, r1
	movwle	r5, #1
	moveq	r5, r7
	cmp	r5, #0
	bne	.LBB77_18
@ BB#2:
	ldr	r7, .LCPI77_5
	ldr	r5, .LCPI77_4
.LPC77_1:
	add	r7, pc, r7
	ldr	r7, [r5, r7]
	str	r7, [sp, #16]           @ 4-byte Spill
	ldr	r7, .LCPI77_8
.LPC77_3:
	add	r7, pc, r7
	ldr	r5, [r5, r7]
	ldr	r7, .LCPI77_13
	str	r5, [sp, #8]            @ 4-byte Spill
.LPC77_7:
	add	r7, pc, r7
	ldr	r5, .LCPI77_9
.LPC77_4:
	add	r5, pc, r5
	ldr	r5, [r6, r5]
	str	r5, [sp, #12]           @ 4-byte Spill
	ldr	r5, .LCPI77_10
.LPC77_5:
	add	r5, pc, r5
	ldr	r5, [r6, r5]
	ldr	r6, .LCPI77_12
	str	r5, [sp, #4]            @ 4-byte Spill
.LPC77_6:
	add	r6, pc, r6
	ldr	r5, .LCPI77_11
	ldr	r6, [r5, r6]
	ldr	r5, [r5, r7]
	ldr	r7, .LCPI77_14
	str	r5, [sp]                @ 4-byte Spill
.LPC77_8:
	add	r7, pc, r7
	ldr	r5, .LCPI77_15
	ldr	r10, [lr, r7]
.LPC77_9:
	add	r5, pc, r5
	ldr	r9, [r12, r5]
	ldr	r8, [lr, r5]
.LBB77_3:                               @ %.lr.ph9
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB77_5 Depth 2
                                        @     Child Loop BB77_14 Depth 2
	ldr	r7, [r4, #4]
	ldr	r5, [r4, #24]
	cmp	r5, #0
	bne	.LBB77_16
@ BB#4:                                 @   in Loop: Header=BB77_3 Depth=1
	ldrb	r0, [r4, #20]
	ldr	r1, [sp, #16]           @ 4-byte Reload
	ldr	r1, [r1, r0, lsl #2]
	cmp	r1, r4
	beq	.LBB77_8
.LBB77_5:                               @ %.preheader2
                                        @   Parent Loop BB77_3 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	mov	r0, r1
	cmp	r0, #0
	beq	.LBB77_19
@ BB#6:                                 @   in Loop: Header=BB77_5 Depth=2
	ldr	r1, [r0]
	cmp	r1, r4
	bne	.LBB77_5
@ BB#7:                                 @ %.critedge
                                        @   in Loop: Header=BB77_3 Depth=1
	ldr	r1, [r4]
	str	r1, [r0]
	b	.LBB77_9
.LBB77_8:                               @   in Loop: Header=BB77_3 Depth=1
	ldr	r1, [r4]
	ldr	r2, [sp, #8]            @ 4-byte Reload
	str	r1, [r2, r0, lsl #2]
.LBB77_9:                               @   in Loop: Header=BB77_3 Depth=1
	ldr	r0, [sp, #12]           @ 4-byte Reload
	ldr	r0, [r0]
	cmp	r0, r4
	bne	.LBB77_11
@ BB#10:                                @   in Loop: Header=BB77_3 Depth=1
	ldr	r0, [sp, #4]            @ 4-byte Reload
	str	r7, [r0]
.LBB77_11:                              @   in Loop: Header=BB77_3 Depth=1
	cmp	r7, #0
	ldrne	r0, [r4, #8]
	strne	r0, [r7, #8]
	ldr	r0, [r6]
	cmp	r0, r4
	bne	.LBB77_13
@ BB#12:                                @   in Loop: Header=BB77_3 Depth=1
	ldr	r0, [r4, #8]
	ldr	r1, [sp]                @ 4-byte Reload
	str	r0, [r1]
.LBB77_13:                              @ %._crit_edge.14
                                        @   in Loop: Header=BB77_3 Depth=1
	ldr	r0, [r4, #8]
	mov	r5, #0
	cmp	r0, #0
	strne	r7, [r4, #8]
	ldr	r0, [r4, #28]
	cmp	r0, #0
	beq	.LBB77_15
.LBB77_14:                              @ %.lr.ph
                                        @   Parent Loop BB77_3 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	mov	r0, r4
	mov	r1, r5
	bl	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi(PLT)
	bl	_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t(PLT)
	ldrd	r2, r3, [r10]
	add	r5, r5, #1
	subs	r0, r2, r0
	sbc	r1, r3, #0
	strd	r0, r1, [r10]
	ldr	r0, [r4, #28]
	cmp	r5, r0
	blo	.LBB77_14
.LBB77_15:                              @ %._crit_edge
                                        @   in Loop: Header=BB77_3 Depth=1
	mov	r0, r4
	bl	_ZN6Halide7Runtime8Internal10CacheEntry7destroyEv(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	ldrd	r0, r1, [r9]
	ldrd	r2, r3, [r8]
.LBB77_16:                              @ %.backedge
                                        @   in Loop: Header=BB77_3 Depth=1
	cmp	r7, #0
	beq	.LBB77_18
@ BB#17:                                @ %.backedge
                                        @   in Loop: Header=BB77_3 Depth=1
	cmp	r2, r0
	mov	r5, #0
	movwhi	r5, #1
	cmp	r3, r1
	mov	r4, #0
	movwgt	r4, #1
	moveq	r4, r5
	cmp	r4, #0
	mov	r4, r7
	bne	.LBB77_3
.LBB77_18:                              @ %._crit_edge.10
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB77_19:                              @ %.critedge1
	ldr	r0, .LCPI77_6
	ldr	r1, .LCPI77_7
.LPC77_2:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, #0
	bl	halide_print(PLT)
	bl	abort(PLT)
	.align	2
@ BB#20:
.LCPI77_0:
	.long	_ZN6Halide7Runtime8Internal14max_cache_sizeE(GOT)
.LCPI77_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_0+8)
.LCPI77_2:
	.long	_ZN6Halide7Runtime8Internal18current_cache_sizeE(GOT)
.LCPI77_3:
	.long	_ZN6Halide7Runtime8Internal19least_recently_usedE(GOT)
.LCPI77_4:
	.long	_ZN6Halide7Runtime8Internal13cache_entriesE(GOT)
.LCPI77_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_1+8)
.LCPI77_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_2+8)
.LCPI77_7:
	.long	.L.str.70(GOTOFF)
.LCPI77_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_3+8)
.LCPI77_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_4+8)
.LCPI77_10:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_5+8)
.LCPI77_11:
	.long	_ZN6Halide7Runtime8Internal18most_recently_usedE(GOT)
.LCPI77_12:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_6+8)
.LCPI77_13:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_7+8)
.LCPI77_14:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_8+8)
.LCPI77_15:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC77_9+8)
.Lfunc_end77:
	.size	_ZN6Halide7Runtime8Internal11prune_cacheEv, .Lfunc_end77-_ZN6Halide7Runtime8Internal11prune_cacheEv
	.cantunwind
	.fnend

	.section	.text.halide_memoization_cache_set_size,"ax",%progbits
	.weak	halide_memoization_cache_set_size
	.align	2
	.type	halide_memoization_cache_set_size,%function
halide_memoization_cache_set_size:      @ @halide_memoization_cache_set_size
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r11, lr}
	push	{r4, r5, r6, r7, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r1
	mov	r6, r0
	ldr	r1, .LCPI78_1
	ldr	r0, .LCPI78_0
.LPC78_0:
	add	r7, pc, r1
	ldr	r5, [r0, r7]
	mov	r0, r5
	bl	halide_mutex_lock(PLT)
	ldr	r0, .LCPI78_2
	ldr	r0, [r0, r7]
	orrs	r7, r6, r4
	movne	r7, r4
	moveq	r6, #1048576
	strd	r6, r7, [r0]
	bl	_ZN6Halide7Runtime8Internal11prune_cacheEv(PLT)
	mov	r0, r5
	pop	{r4, r5, r6, r7, r11, lr}
	b	halide_mutex_unlock(PLT)
	.align	2
@ BB#1:
.LCPI78_0:
	.long	_ZN6Halide7Runtime8Internal16memoization_lockE(GOT)
.LCPI78_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC78_0+8)
.LCPI78_2:
	.long	_ZN6Halide7Runtime8Internal14max_cache_sizeE(GOT)
.Lfunc_end78:
	.size	halide_memoization_cache_set_size, .Lfunc_end78-halide_memoization_cache_set_size
	.cantunwind
	.fnend

	.section	.text.halide_memoization_cache_lookup,"ax",%progbits
	.weak	halide_memoization_cache_lookup
	.align	2
	.type	halide_memoization_cache_lookup,%function
halide_memoization_cache_lookup:        @ @halide_memoization_cache_lookup
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#12
	sub	sp, sp, #12
	mov	r7, r2
	str	r0, [sp, #8]            @ 4-byte Spill
	str	r1, [sp, #4]            @ 4-byte Spill
	mov	r0, r1
	mov	r1, r7
	str	r3, [sp]                @ 4-byte Spill
	bl	_ZN6Halide7Runtime8Internal8djb_hashEPKhj(PLT)
	mov	r10, r0
	ldr	r0, .LCPI79_1
	ldr	r1, .LCPI79_0
.LPC79_0:
	add	r4, pc, r0
	ldr	r0, [r1, r4]
	bl	halide_mutex_lock(PLT)
	ldr	r0, .LCPI79_2
	uxtb	r1, r10
	ldr	r6, [r11, #8]
	ldr	r0, [r0, r4]
	ldr	r5, [r0, r1, lsl #2]
	cmp	r5, #0
	beq	.LBB79_17
@ BB#1:                                 @ %.lr.ph35
	cmp	r6, #1
	blt	.LBB79_11
.LBB79_2:                               @ %.lr.ph35.split.us
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB79_7 Depth 2
	ldr	r0, [r5, #20]
	cmp	r0, r10
	bne	.LBB79_10
@ BB#3:                                 @   in Loop: Header=BB79_2 Depth=1
	ldr	r0, [r5, #12]
	cmp	r0, r7
	bne	.LBB79_10
@ BB#4:                                 @   in Loop: Header=BB79_2 Depth=1
	ldr	r0, [r5, #16]
	mov	r2, r7
	ldr	r1, [sp, #4]            @ 4-byte Reload
	bl	_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j(PLT)
	cmp	r0, #1
	bne	.LBB79_10
@ BB#5:                                 @   in Loop: Header=BB79_2 Depth=1
	ldr	r1, [sp]                @ 4-byte Reload
	add	r0, r5, #32
	bl	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_(PLT)
	cmp	r0, #1
	bne	.LBB79_10
@ BB#6:                                 @   in Loop: Header=BB79_2 Depth=1
	ldr	r9, [r11, #12]
	mov	r4, #0
	ldr	r0, [r5, #28]
	cmp	r0, r6
	bne	.LBB79_10
.LBB79_7:                               @ %.lr.ph31.us
                                        @   Parent Loop BB79_2 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	mov	r0, r5
	mov	r1, r4
	ldr	r8, [r9], #4
	bl	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi(PLT)
	mov	r1, r8
	bl	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_(PLT)
	add	r4, r4, #1
	cmp	r4, r6
	bge	.LBB79_9
@ BB#8:                                 @ %.lr.ph31.us
                                        @   in Loop: Header=BB79_7 Depth=2
	cmp	r0, #0
	bne	.LBB79_7
.LBB79_9:                               @ %.critedge.us
                                        @   in Loop: Header=BB79_2 Depth=1
	cmp	r0, #0
	bne	.LBB79_24
.LBB79_10:                              @   in Loop: Header=BB79_2 Depth=1
	ldr	r5, [r5]
	cmp	r5, #0
	bne	.LBB79_2
	b	.LBB79_17
.LBB79_11:                              @ %.lr.ph35..lr.ph35.split_crit_edge
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r5, #20]
	cmp	r0, r10
	bne	.LBB79_16
@ BB#12:                                @   in Loop: Header=BB79_11 Depth=1
	ldr	r0, [r5, #12]
	cmp	r0, r7
	bne	.LBB79_16
@ BB#13:                                @   in Loop: Header=BB79_11 Depth=1
	ldr	r0, [r5, #16]
	mov	r2, r7
	ldr	r1, [sp, #4]            @ 4-byte Reload
	bl	_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j(PLT)
	cmp	r0, #1
	bne	.LBB79_16
@ BB#14:                                @   in Loop: Header=BB79_11 Depth=1
	ldr	r1, [sp]                @ 4-byte Reload
	add	r0, r5, #32
	bl	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_(PLT)
	cmp	r0, #1
	bne	.LBB79_16
@ BB#15:                                @   in Loop: Header=BB79_11 Depth=1
	ldr	r0, [r5, #28]
	cmp	r0, r6
	beq	.LBB79_24
.LBB79_16:                              @   in Loop: Header=BB79_11 Depth=1
	ldr	r5, [r5]
	cmp	r5, #0
	bne	.LBB79_11
.LBB79_17:                              @ %.preheader17
	mov	r8, #1
	cmp	r6, #0
	ble	.LBB79_39
@ BB#18:
	ldr	r5, [r11, #12]
	mov	r7, #0
	mov	r9, #0
.LBB79_19:                              @ %.lr.ph26
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r4, [r5]
	mov	r0, r4
	bl	_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t(PLT)
	add	r1, r0, #16
	ldr	r0, [sp, #8]            @ 4-byte Reload
	bl	halide_malloc(PLT)
	str	r0, [r4, #8]
	cmp	r0, #0
	beq	.LBB79_21
@ BB#20:                                @   in Loop: Header=BB79_19 Depth=1
	add	r0, r0, #16
	str	r0, [r4, #8]
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	add	r7, r7, #1
	add	r5, r5, #4
	stm	r0, {r9, r10}
	cmp	r7, r6
	blt	.LBB79_19
	b	.LBB79_39
.LBB79_21:                              @ %.preheader
	mvn	r8, #0
	cmp	r7, #1
	blt	.LBB79_39
@ BB#22:                                @ %.lr.ph.preheader
	ldr	r0, [r11, #12]
	add	r5, r7, #1
	mov	r6, #0
	add	r0, r0, r7, lsl #2
	ldr	r7, [sp, #8]            @ 4-byte Reload
	sub	r4, r0, #4
.LBB79_23:                              @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r4]
	ldr	r0, [r0, #8]
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	mov	r1, r0
	mov	r0, r7
	bl	halide_free(PLT)
	ldr	r0, [r4], #-4
	sub	r5, r5, #1
	cmp	r5, #1
	str	r6, [r0, #8]
	bgt	.LBB79_23
	b	.LBB79_39
.LBB79_24:                              @ %.us-lcssa.us
	ldr	r0, .LCPI79_4
	ldr	r4, .LCPI79_3
.LPC79_1:
	add	r0, pc, r0
	ldr	r7, [r11, #12]
	ldr	r0, [r4, r0]
	mov	r8, r7
	ldr	r7, [sp, #8]            @ 4-byte Reload
	ldr	r0, [r0]
	cmp	r5, r0
	beq	.LBB79_35
@ BB#25:
	ldr	r0, [r5, #4]
	cmp	r0, #0
	bne	.LBB79_27
@ BB#26:
	ldr	r0, .LCPI79_5
	ldr	r1, .LCPI79_6
.LPC79_2:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r7
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB79_27:
	ldr	r0, [r5, #8]
	cmp	r0, #0
	beq	.LBB79_29
@ BB#28:
	ldr	r1, [r5, #4]
	str	r1, [r0, #4]
	b	.LBB79_32
.LBB79_29:
	ldr	r0, .LCPI79_8
	ldr	r9, .LCPI79_7
.LPC79_3:
	add	r0, pc, r0
	ldr	r0, [r9, r0]
	ldr	r0, [r0]
	cmp	r0, r5
	beq	.LBB79_31
@ BB#30:
	ldr	r0, .LCPI79_9
	ldr	r1, .LCPI79_10
.LPC79_4:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r7
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB79_31:
	ldr	r0, .LCPI79_11
	ldr	r1, [r5, #4]
.LPC79_5:
	add	r0, pc, r0
	ldr	r0, [r9, r0]
	str	r1, [r0]
.LBB79_32:
	ldr	r0, [r5, #4]
	cmp	r0, #0
	bne	.LBB79_34
@ BB#33:
	ldr	r0, .LCPI79_12
	ldr	r1, .LCPI79_13
.LPC79_6:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r7
	bl	halide_print(PLT)
	bl	abort(PLT)
	ldr	r0, [r5, #4]
.LBB79_34:
	ldr	r1, .LCPI79_14
	ldr	r2, [r5, #8]
.LPC79_7:
	add	r1, pc, r1
	ldr	r1, [r4, r1]
	str	r2, [r0, #8]
	mov	r0, #0
	str	r0, [r5, #4]
	ldr	r0, [r1]
	str	r0, [r5, #8]
	ldr	r0, [r1]
	cmp	r0, #0
	strne	r5, [r0, #4]
	ldr	r0, .LCPI79_15
.LPC79_8:
	add	r0, pc, r0
	ldr	r0, [r4, r0]
	str	r5, [r0]
.LBB79_35:                              @ %.preheader19
	cmp	r6, #0
	ble	.LBB79_38
@ BB#36:
	mov	r4, #0
.LBB79_37:                              @ %.lr.ph28
                                        @ =>This Inner Loop Header: Depth=1
	mov	r0, r5
	mov	r1, r4
	ldr	r7, [r8], #4
	bl	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi(PLT)
	mov	r1, r0
	mov	r0, r7
	mov	r2, #72
	bl	__aeabi_memcpy8(PLT)
	add	r4, r4, #1
	cmp	r6, r4
	bne	.LBB79_37
.LBB79_38:                              @ %.critedge12
	ldr	r0, [r5, #24]
	mov	r8, #0
	add	r0, r0, r6
	str	r0, [r5, #24]
.LBB79_39:
	ldr	r0, .LCPI79_16
	ldr	r1, .LCPI79_0
.LPC79_9:
	add	r0, pc, r0
	ldr	r0, [r1, r0]
	bl	halide_mutex_unlock(PLT)
	mov	r0, r8
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#40:
.LCPI79_0:
	.long	_ZN6Halide7Runtime8Internal16memoization_lockE(GOT)
.LCPI79_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_0+8)
.LCPI79_2:
	.long	_ZN6Halide7Runtime8Internal13cache_entriesE(GOT)
.LCPI79_3:
	.long	_ZN6Halide7Runtime8Internal18most_recently_usedE(GOT)
.LCPI79_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_1+8)
.LCPI79_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_2+8)
.LCPI79_6:
	.long	.L.str.1.71(GOTOFF)
.LCPI79_7:
	.long	_ZN6Halide7Runtime8Internal19least_recently_usedE(GOT)
.LCPI79_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_3+8)
.LCPI79_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_4+8)
.LCPI79_10:
	.long	.L.str.2.72(GOTOFF)
.LCPI79_11:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_5+8)
.LCPI79_12:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_6+8)
.LCPI79_13:
	.long	.L.str.3.73(GOTOFF)
.LCPI79_14:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_7+8)
.LCPI79_15:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_8+8)
.LCPI79_16:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC79_9+8)
.Lfunc_end79:
	.size	halide_memoization_cache_lookup, .Lfunc_end79-halide_memoization_cache_lookup
	.cantunwind
	.fnend

	.section	.text.halide_memoization_cache_store,"ax",%progbits
	.weak	halide_memoization_cache_store
	.align	2
	.type	halide_memoization_cache_store,%function
halide_memoization_cache_store:         @ @halide_memoization_cache_store
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#36
	sub	sp, sp, #36
	ldr	r10, [r11, #12]
	mov	r6, r2
	str	r0, [sp, #16]           @ 4-byte Spill
	mov	r8, r1
	str	r3, [sp, #32]           @ 4-byte Spill
	ldr	r0, [r10]
	ldr	r0, [r0, #8]
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	ldr	r1, .LCPI80_1
	ldr	r9, .LCPI80_0
.LPC80_0:
	add	r4, pc, r1
	ldr	r5, [r0, #4]
	ldr	r1, [r9, r4]
	str	r5, [sp, #20]           @ 4-byte Spill
	mov	r0, r1
	bl	halide_mutex_lock(PLT)
	ldr	r0, .LCPI80_2
	mov	r3, r5
	uxtb	r1, r3
	ldr	r5, [r11, #8]
	ldr	r0, [r0, r4]
	str	r1, [sp, #12]           @ 4-byte Spill
	ldr	r7, [r0, r1, lsl #2]
	cmp	r7, #0
	beq	.LBB80_18
@ BB#1:                                 @ %.lr.ph36
	cmp	r5, #1
	blt	.LBB80_12
.LBB80_2:                               @ %.lr.ph36.split.us
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB80_8 Depth 2
	ldr	r0, [r7, #20]
	cmp	r0, r3
	bne	.LBB80_11
@ BB#3:                                 @   in Loop: Header=BB80_2 Depth=1
	ldr	r0, [r7, #12]
	cmp	r0, r6
	bne	.LBB80_11
@ BB#4:                                 @   in Loop: Header=BB80_2 Depth=1
	ldr	r0, [r7, #16]
	mov	r1, r8
	mov	r2, r6
	mov	r4, r3
	bl	_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j(PLT)
	mov	r3, r4
	cmp	r0, #1
	bne	.LBB80_11
@ BB#5:                                 @   in Loop: Header=BB80_2 Depth=1
	ldr	r1, [sp, #32]           @ 4-byte Reload
	add	r0, r7, #32
	mov	r4, r3
	bl	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_(PLT)
	mov	r3, r4
	cmp	r0, #1
	bne	.LBB80_11
@ BB#6:                                 @   in Loop: Header=BB80_2 Depth=1
	ldr	r0, [r7, #28]
	cmp	r0, r5
	bne	.LBB80_11
@ BB#7:                                 @   in Loop: Header=BB80_2 Depth=1
	str	r6, [sp, #28]           @ 4-byte Spill
	mov	r6, #0
	mov	r4, #1
	str	r8, [sp, #24]           @ 4-byte Spill
.LBB80_8:                               @ %.lr.ph28.us
                                        @   Parent Loop BB80_2 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	mov	r0, r7
	mov	r1, r6
	ldr	r9, [r10], #4
	bl	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi(PLT)
	mov	r1, r9
	bl	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_(PLT)
	mov	r8, r0
	mov	r0, r7
	mov	r1, r6
	bl	_ZN6Halide7Runtime8Internal10CacheEntry6bufferEi(PLT)
	ldr	r0, [r0, #8]
	add	r6, r6, #1
	ldr	r1, [r9, #8]
	cmp	r0, r1
	mov	r0, #0
	movwne	r0, #1
	cmp	r6, r5
	and	r4, r4, r0
	bge	.LBB80_10
@ BB#9:                                 @ %.lr.ph28.us
                                        @   in Loop: Header=BB80_8 Depth=2
	cmp	r8, #0
	bne	.LBB80_8
.LBB80_10:                              @ %.critedge.us
                                        @   in Loop: Header=BB80_2 Depth=1
	cmp	r8, #0
	ldr	r9, .LCPI80_0
	ldr	r10, [r11, #12]
	ldr	r6, [sp, #28]           @ 4-byte Reload
	ldr	r8, [sp, #24]           @ 4-byte Reload
	ldr	r3, [sp, #20]           @ 4-byte Reload
	bne	.LBB80_36
.LBB80_11:                              @   in Loop: Header=BB80_2 Depth=1
	ldr	r7, [r7]
	cmp	r7, #0
	bne	.LBB80_2
	b	.LBB80_18
.LBB80_12:                              @ %.lr.ph36..lr.ph36.split_crit_edge
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r7, #20]
	cmp	r0, r3
	bne	.LBB80_17
@ BB#13:                                @   in Loop: Header=BB80_12 Depth=1
	ldr	r0, [r7, #12]
	cmp	r0, r6
	bne	.LBB80_17
@ BB#14:                                @   in Loop: Header=BB80_12 Depth=1
	ldr	r0, [r7, #16]
	mov	r1, r8
	mov	r2, r6
	mov	r4, r3
	bl	_ZN6Halide7Runtime8Internal10keys_equalEPKhS3_j(PLT)
	mov	r3, r4
	cmp	r0, #1
	bne	.LBB80_17
@ BB#15:                                @   in Loop: Header=BB80_12 Depth=1
	ldr	r1, [sp, #32]           @ 4-byte Reload
	add	r0, r7, #32
	mov	r4, r3
	bl	_ZN6Halide7Runtime8Internal12bounds_equalERK8buffer_tS4_(PLT)
	mov	r3, r4
	cmp	r0, #1
	bne	.LBB80_17
@ BB#16:                                @   in Loop: Header=BB80_12 Depth=1
	ldr	r0, [r7, #28]
	cmp	r0, r5
	beq	.LBB80_38
.LBB80_17:                              @   in Loop: Header=BB80_12 Depth=1
	ldr	r7, [r7]
	cmp	r7, #0
	bne	.LBB80_12
.LBB80_18:                              @ %.preheader
	str	r6, [sp, #28]           @ 4-byte Spill
	mov	r6, #0
	mov	r9, r3
	str	r8, [sp, #24]           @ 4-byte Spill
	cmp	r5, #0
	ble	.LBB80_21
@ BB#19:
	mov	r0, r5
	mov	r4, r10
	mov	r8, r0
	mov	r7, #0
.LBB80_20:                              @ %.lr.ph21
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r4], #4
	bl	_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t(PLT)
	adds	r6, r0, r6
	adc	r7, r7, #0
	subs	r5, r5, #1
	bne	.LBB80_20
	b	.LBB80_22
.LBB80_21:
	mov	r8, r5
	mov	r7, #0
.LBB80_22:                              @ %._crit_edge.22
	ldr	r0, .LCPI80_6
	ldr	r4, .LCPI80_5
.LPC80_2:
	add	r0, pc, r0
	ldr	r0, [r4, r0]
	ldrd	r2, r3, [r0]
	adds	r2, r2, r6
	adc	r3, r3, r7
	strd	r2, r3, [r0]
	bl	_ZN6Halide7Runtime8Internal11prune_cacheEv(PLT)
	mov	r5, r8
	mov	r1, #104
	add	r0, r5, r5, lsl #3
	add	r1, r1, r0, lsl #3
	mov	r0, #0
	bl	halide_malloc(PLT)
	mov	r8, r0
	cmp	r8, #0
	beq	.LBB80_28
@ BB#23:
	ldr	r0, [sp, #32]           @ 4-byte Reload
	mov	r3, r9
	stm	sp, {r0, r5, r10}
	mov	r0, r8
	ldr	r1, [sp, #24]           @ 4-byte Reload
	ldr	r2, [sp, #28]           @ 4-byte Reload
	bl	_ZN6Halide7Runtime8Internal10CacheEntry4initEPKhjjRK8buffer_tiPPS5_(PLT)
	cmp	r0, #0
	beq	.LBB80_31
@ BB#24:
	ldr	r0, .LCPI80_8
	ldr	r3, .LCPI80_2
.LPC80_4:
	add	r1, pc, r0
	ldr	r7, [sp, #12]           @ 4-byte Reload
	ldr	r0, .LCPI80_9
	ldr	r2, [r3, r1]
	ldr	r9, .LCPI80_0
	ldr	r1, [r0, r1]
	ldr	r2, [r2, r7, lsl #2]
	str	r2, [r8]
	ldr	r2, [r1]
	str	r2, [r8, #8]
	ldr	r1, [r1]
	ldr	r2, .LCPI80_10
	cmp	r1, #0
	strne	r8, [r1, #4]
.LPC80_5:
	add	r2, pc, r2
	ldr	r1, .LCPI80_11
	ldr	r0, [r0, r2]
	ldr	r2, [r1, r2]
	str	r8, [r0]
	ldr	r0, [r2]
	cmp	r0, #0
	bne	.LBB80_26
@ BB#25:
	ldr	r0, .LCPI80_12
.LPC80_6:
	add	r0, pc, r0
	ldr	r0, [r1, r0]
	str	r8, [r0]
.LBB80_26:
	ldr	r0, .LCPI80_13
	cmp	r5, #1
.LPC80_7:
	add	r0, pc, r0
	ldr	r0, [r3, r0]
	str	r8, [r0, r7, lsl #2]
	str	r5, [r8, #24]
	blt	.LBB80_35
.LBB80_27:                              @ %.lr.ph16
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r10], #4
	ldr	r0, [r0, #8]
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	subs	r5, r5, #1
	str	r8, [r0]
	bne	.LBB80_27
	b	.LBB80_35
.LBB80_28:
	ldr	r0, .LCPI80_14
	ldr	r9, .LCPI80_0
.LPC80_8:
	add	r0, pc, r0
	ldr	r0, [r4, r0]
	ldrd	r2, r3, [r0]
	subs	r2, r2, r6
	sbc	r3, r3, r7
	cmp	r5, #1
	strd	r2, r3, [r0]
	blt	.LBB80_35
@ BB#29:
	mov	r4, #0
.LBB80_30:                              @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r10], #4
	ldr	r0, [r0, #8]
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	subs	r5, r5, #1
	str	r4, [r0]
	bne	.LBB80_30
	b	.LBB80_35
.LBB80_31:
	ldr	r0, .LCPI80_7
.LPC80_3:
	add	r0, pc, r0
	ldr	r0, [r4, r0]
	ldrd	r2, r3, [r0]
	subs	r2, r2, r6
	sbc	r3, r3, r7
	cmp	r5, #0
	strd	r2, r3, [r0]
	ble	.LBB80_34
@ BB#32:
	mov	r4, #0
.LBB80_33:                              @ %.lr.ph18
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r10], #4
	ldr	r0, [r0, #8]
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	subs	r5, r5, #1
	str	r4, [r0]
	bne	.LBB80_33
.LBB80_34:                              @ %._crit_edge
	ldr	r0, [sp, #16]           @ 4-byte Reload
	mov	r1, r8
	bl	halide_free(PLT)
	ldr	r9, .LCPI80_0
.LBB80_35:                              @ %.critedge9
	ldr	r0, .LCPI80_15
.LPC80_9:
	add	r0, pc, r0
	ldr	r0, [r9, r0]
	bl	halide_mutex_unlock(PLT)
	mov	r0, #0
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB80_36:                              @ %.us-lcssa.us
	cmp	r4, #0
	bne	.LBB80_38
@ BB#37:
	ldr	r0, .LCPI80_3
	ldr	r1, .LCPI80_4
.LPC80_1:
	add	r0, pc, r0
	add	r1, r1, r0
	ldr	r0, [sp, #16]           @ 4-byte Reload
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB80_38:                              @ %.preheader11
	cmp	r5, #1
	blt	.LBB80_35
@ BB#39:
	mov	r4, #0
.LBB80_40:                              @ %.lr.ph24
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r10], #4
	ldr	r0, [r0, #8]
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	subs	r5, r5, #1
	str	r4, [r0]
	bne	.LBB80_40
	b	.LBB80_35
	.align	2
@ BB#41:
.LCPI80_0:
	.long	_ZN6Halide7Runtime8Internal16memoization_lockE(GOT)
.LCPI80_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_0+8)
.LCPI80_2:
	.long	_ZN6Halide7Runtime8Internal13cache_entriesE(GOT)
.LCPI80_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_1+8)
.LCPI80_4:
	.long	.L.str.5.74(GOTOFF)
.LCPI80_5:
	.long	_ZN6Halide7Runtime8Internal18current_cache_sizeE(GOT)
.LCPI80_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_2+8)
.LCPI80_7:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_3+8)
.LCPI80_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_4+8)
.LCPI80_9:
	.long	_ZN6Halide7Runtime8Internal18most_recently_usedE(GOT)
.LCPI80_10:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_5+8)
.LCPI80_11:
	.long	_ZN6Halide7Runtime8Internal19least_recently_usedE(GOT)
.LCPI80_12:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_6+8)
.LCPI80_13:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_7+8)
.LCPI80_14:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_8+8)
.LCPI80_15:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC80_9+8)
.Lfunc_end80:
	.size	halide_memoization_cache_store, .Lfunc_end80-halide_memoization_cache_store
	.cantunwind
	.fnend

	.section	.text.halide_memoization_cache_release,"ax",%progbits
	.weak	halide_memoization_cache_release
	.align	2
	.type	halide_memoization_cache_release,%function
halide_memoization_cache_release:       @ @halide_memoization_cache_release
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r0
	mov	r0, r1
	bl	_ZN6Halide7Runtime8Internal21get_pointer_to_headerEPh(PLT)
	mov	r1, r0
	ldr	r5, [r1]
	cmp	r5, #0
	beq	.LBB81_4
@ BB#1:
	ldr	r0, .LCPI81_1
	ldr	r6, .LCPI81_0
.LPC81_0:
	add	r0, pc, r0
	ldr	r0, [r6, r0]
	bl	halide_mutex_lock(PLT)
	ldr	r1, [r5, #24]
	cmp	r1, #0
	bne	.LBB81_3
@ BB#2:
	ldr	r0, .LCPI81_2
	ldr	r1, .LCPI81_3
.LPC81_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r4
	bl	halide_print(PLT)
	bl	abort(PLT)
	ldr	r1, [r5, #24]
.LBB81_3:
	ldr	r0, .LCPI81_4
	sub	r1, r1, #1
	str	r1, [r5, #24]
.LPC81_2:
	add	r0, pc, r0
	ldr	r0, [r6, r0]
	pop	{r4, r5, r6, r10, r11, lr}
	b	halide_mutex_unlock(PLT)
.LBB81_4:
	mov	r0, r4
	pop	{r4, r5, r6, r10, r11, lr}
	b	halide_free(PLT)
	.align	2
@ BB#5:
.LCPI81_0:
	.long	_ZN6Halide7Runtime8Internal16memoization_lockE(GOT)
.LCPI81_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC81_0+8)
.LCPI81_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC81_1+8)
.LCPI81_3:
	.long	.L.str.8.75(GOTOFF)
.LCPI81_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC81_2+8)
.Lfunc_end81:
	.size	halide_memoization_cache_release, .Lfunc_end81-halide_memoization_cache_release
	.cantunwind
	.fnend

	.section	.text.halide_memoization_cache_cleanup,"ax",%progbits
	.weak	halide_memoization_cache_cleanup
	.align	2
	.type	halide_memoization_cache_cleanup,%function
halide_memoization_cache_cleanup:       @ @halide_memoization_cache_cleanup
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	ldr	r1, .LCPI82_1
	mov	r8, #0
	ldr	r0, .LCPI82_0
	mov	r7, #0
.LPC82_0:
	add	r1, pc, r1
	ldr	r6, [r0, r1]
.LBB82_1:                               @ =>This Loop Header: Depth=1
                                        @     Child Loop BB82_2 Depth 2
	ldr	r4, [r6, r7, lsl #2]
	str	r8, [r6, r7, lsl #2]
	cmp	r4, #0
	beq	.LBB82_3
.LBB82_2:                               @ %.lr.ph
                                        @   Parent Loop BB82_1 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	mov	r0, r4
	ldr	r5, [r4]
	bl	_ZN6Halide7Runtime8Internal10CacheEntry7destroyEv(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	mov	r4, r5
	cmp	r5, #0
	bne	.LBB82_2
.LBB82_3:                               @ %._crit_edge
                                        @   in Loop: Header=BB82_1 Depth=1
	add	r7, r7, #1
	cmp	r7, #256
	bne	.LBB82_1
@ BB#4:
	ldr	r1, .LCPI82_3
	ldr	r0, .LCPI82_2
.LPC82_1:
	add	r1, pc, r1
	ldr	r2, .LCPI82_4
	ldr	r3, [r0, r1]
	ldr	r0, [r2, r1]
	mov	r1, #0
	str	r1, [r3]
	str	r1, [r3, #4]
	pop	{r4, r5, r6, r7, r8, r10, r11, lr}
	b	halide_mutex_destroy(PLT)
	.align	2
@ BB#5:
.LCPI82_0:
	.long	_ZN6Halide7Runtime8Internal13cache_entriesE(GOT)
.LCPI82_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC82_0+8)
.LCPI82_2:
	.long	_ZN6Halide7Runtime8Internal18current_cache_sizeE(GOT)
.LCPI82_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC82_1+8)
.LCPI82_4:
	.long	_ZN6Halide7Runtime8Internal16memoization_lockE(GOT)
.Lfunc_end82:
	.size	halide_memoization_cache_cleanup, .Lfunc_end82-halide_memoization_cache_cleanup
	.cantunwind
	.fnend

	.section	.text.halide_cache_cleanup,"ax",%progbits
	.weak	halide_cache_cleanup
	.align	2
	.type	halide_cache_cleanup,%function
halide_cache_cleanup:                   @ @halide_cache_cleanup
	.fnstart
@ BB#0:
	b	halide_memoization_cache_cleanup(PLT)
.Lfunc_end83:
	.size	halide_cache_cleanup, .Lfunc_end83-halide_cache_cleanup
	.cantunwind
	.fnend

	.section	.text.halide_string_to_string,"ax",%progbits
	.weak	halide_string_to_string
	.align	2
	.type	halide_string_to_string,%function
halide_string_to_string:                @ @halide_string_to_string
	.fnstart
@ BB#0:
	cmp	r0, r1
	bhs	.LBB84_5
@ BB#1:                                 @ %.preheader
	beq	.LBB84_4
.LBB84_2:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	ldrb	r3, [r2]
	cmp	r3, #0
	strb	r3, [r0]
	bxeq	lr
	add	r0, r0, #1
	add	r2, r2, #1
	cmp	r1, r0
	bne	.LBB84_2
@ BB#3:
	mov	r0, r1
.LBB84_4:                               @ %._crit_edge
	mov	r1, #0
	strb	r1, [r0, #-1]
.LBB84_5:                               @ %.loopexit
	bx	lr
.Lfunc_end84:
	.size	halide_string_to_string, .Lfunc_end84-halide_string_to_string
	.cantunwind
	.fnend

	.section	.text.halide_uint64_to_string,"ax",%progbits
	.weak	halide_uint64_to_string
	.align	2
	.type	halide_uint64_to_string,%function
halide_uint64_to_string:                @ @halide_uint64_to_string
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#36
	sub	sp, sp, #36
	mov	r7, r2
	mov	r9, r0
	mov	r0, #0
	mov	r6, r3
	ldr	r10, [r11, #8]
	mov	r8, r1
	strb	r0, [sp, #35]
	orrs	r0, r7, r6
	add	r0, sp, #4
	mov	r2, #1
	add	r5, r0, #30
	bne	.LBB85_2
@ BB#1:
	cmp	r10, #0
	ble	.LBB85_4
.LBB85_2:                               @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	mov	r4, r2
	mov	r0, r7
	mov	r1, r6
	mov	r2, #10
	mov	r3, #0
	bl	__aeabi_uldivmod(PLT)
	add	r2, r0, r0, lsl #2
	cmp	r7, #9
	mov	r3, #0
	movwhi	r3, #1
	sub	r2, r7, r2, lsl #1
	cmp	r6, #0
	movwne	r6, #1
	moveq	r6, r3
	add	r2, r2, #48
	cmp	r6, #0
	strb	r2, [r5], #-1
	add	r2, r4, #1
	mov	r7, r0
	mov	r6, r1
	bne	.LBB85_2
@ BB#3:                                 @ %.lr.ph
                                        @   in Loop: Header=BB85_2 Depth=1
	mov	r7, r0
	mov	r6, r1
	cmp	r4, r10
	blt	.LBB85_2
.LBB85_4:                               @ %._crit_edge
	add	r2, r5, #1
	mov	r0, r9
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.Lfunc_end85:
	.size	halide_uint64_to_string, .Lfunc_end85-halide_uint64_to_string
	.cantunwind
	.fnend

	.section	.text.halide_int64_to_string,"ax",%progbits
	.weak	halide_int64_to_string
	.align	2
	.type	halide_int64_to_string,%function
halide_int64_to_string:                 @ @halide_int64_to_string
	.fnstart
@ BB#0:
	cmp	r0, r1
	bhs	.LBB86_3
@ BB#1:
	cmp	r3, #0
	bge	.LBB86_3
@ BB#2:
	mov	r12, #45
	rsbs	r2, r2, #0
	strb	r12, [r0], #1
	rsc	r3, r3, #0
.LBB86_3:
	b	halide_uint64_to_string(PLT)
.Lfunc_end86:
	.size	halide_int64_to_string, .Lfunc_end86-halide_int64_to_string
	.cantunwind
	.fnend

	.section	.text.halide_double_to_string,"ax",%progbits
	.weak	halide_double_to_string
	.align	3
	.type	halide_double_to_string,%function
halide_double_to_string:                @ @halide_double_to_string
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	.vsave	{d8}
	vpush	{d8}
	.pad	#552
	sub	sp, sp, #552
	vorr	d8, d0, d0
	mov	r10, r0
	mov	r0, #0
	mov	r6, r2
	mov	r9, r1
	str	r0, [r11, #-60]
	str	r0, [r11, #-64]
	sub	r0, r11, #64
	sub	r1, r11, #56
	mov	r2, #8
	vstr	d8, [r11, #-56]
	bl	memcpy(PLT)
	ldr	r1, [r11, #-60]
	ldr	r7, [r11, #-64]
	mov	r5, r1
	lsr	r0, r1, #31
	ubfx	r4, r1, #20, #11
	bfc	r5, #20, #12
	movw	r1, #2047
	cmp	r4, r1
	bne	.LBB87_4
@ BB#1:
	orrs	r1, r7, r5
	beq	.LBB87_18
@ BB#2:
	cmp	r0, #0
	beq	.LBB87_20
@ BB#3:
	ldr	r0, .LCPI87_20
	ldr	r1, .LCPI87_21
.LPC87_10:
	add	r0, pc, r0
	b	.LBB87_37
.LBB87_4:
	orrs	r1, r7, r5
	bne	.LBB87_9
@ BB#5:
	cmp	r4, #0
	bne	.LBB87_9
@ BB#6:
	cmp	r6, #0
	beq	.LBB87_21
@ BB#7:
	cmp	r0, #0
	beq	.LBB87_33
@ BB#8:
	ldr	r0, .LCPI87_12
	ldr	r1, .LCPI87_13
.LPC87_6:
	add	r0, pc, r0
	b	.LBB87_37
.LBB87_9:
	cmp	r0, #0
	beq	.LBB87_11
@ BB#10:
	ldr	r0, .LCPI87_0
	ldr	r1, .LCPI87_1
.LPC87_0:
	add	r0, pc, r0
	add	r2, r1, r0
	mov	r0, r10
	mov	r1, r9
	bl	halide_string_to_string(PLT)
	vneg.f64	d8, d8
	mov	r10, r0
	vstr	d8, [r11, #-56]
.LBB87_11:
	cmp	r6, #0
	beq	.LBB87_23
@ BB#12:                                @ %thread-pre-split
	vmov.f64	d16, #1.000000e+00
	mov	r6, #0
	vcmpe.f64	d8, d16
	vmrs	APSR_nzcv, fpscr
	bpl	.LBB87_16
@ BB#13:
	vmov.f64	d17, #1.000000e+01
.LBB87_14:                              @ %.lr.ph25
                                        @ =>This Inner Loop Header: Depth=1
	vmul.f64	d8, d8, d17
	sub	r6, r6, #1
	vcmpe.f64	d8, d16
	vmrs	APSR_nzcv, fpscr
	bmi	.LBB87_14
@ BB#15:                                @ %.thread-pre-split6_crit_edge
	vstr	d8, [r11, #-56]
.LBB87_16:                              @ %thread-pre-split6
	vmov.f64	d16, #1.000000e+01
	vcmpe.f64	d8, d16
	vmrs	APSR_nzcv, fpscr
	bge	.LBB87_27
@ BB#17:
	str	r10, [sp, #8]           @ 4-byte Spill
	mov	r8, r9
	b	.LBB87_30
.LBB87_18:
	cmp	r0, #0
	beq	.LBB87_32
@ BB#19:
	ldr	r0, .LCPI87_24
	ldr	r1, .LCPI87_25
.LPC87_12:
	add	r0, pc, r0
	b	.LBB87_37
.LBB87_20:
	ldr	r0, .LCPI87_18
	ldr	r1, .LCPI87_19
.LPC87_9:
	add	r0, pc, r0
	b	.LBB87_37
.LBB87_21:
	cmp	r0, #0
	beq	.LBB87_36
@ BB#22:
	ldr	r0, .LCPI87_16
	ldr	r1, .LCPI87_17
.LPC87_8:
	add	r0, pc, r0
	b	.LBB87_37
.LBB87_23:
	cmp	r4, #0
	beq	.LBB87_38
@ BB#24:
	movw	r0, #1075
	orr	r3, r5, #1048576
	sub	r1, r4, r0
	mov	r8, #0
	movw	r0, #1074
	cmp	r4, r0
	bhi	.LBB87_39
@ BB#25:
	mov	r6, #0
	cmn	r1, #52
	str	r1, [sp, #12]           @ 4-byte Spill
	bge	.LBB87_40
@ BB#26:
	mov	r5, #0
	mov	r4, #0
	b	.LBB87_41
.LBB87_27:
	mov	r8, r9
	str	r10, [sp, #8]           @ 4-byte Spill
.LBB87_28:                              @ %.lr.ph19
                                        @ =>This Inner Loop Header: Depth=1
	vdiv.f64	d8, d8, d16
	add	r6, r6, #1
	vcmpe.f64	d8, d16
	vmrs	APSR_nzcv, fpscr
	bge	.LBB87_28
@ BB#29:                                @ %._crit_edge.20
	vstr	d8, [r11, #-56]
.LBB87_30:
	vldr	d16, .LCPI87_2
	vmov.f64	d17, #5.000000e-01
	vmla.f64	d17, d8, d16
	vmov	r0, r1, d17
	bl	__aeabi_d2ulz(PLT)
	movw	r2, #16960
	mov	r3, #0
	movt	r2, #15
	mov	r7, r0
	mov	r5, r1
	bl	__aeabi_uldivmod(PLT)
	movw	r9, #48576
	mov	r2, r0
	movt	r9, #65520
	mov	r4, r1
	umull	r3, r0, r2, r9
	mov	r1, #1
	str	r1, [sp]
	mov	r1, r8
	str	r3, [sp, #12]           @ 4-byte Spill
	mov	r3, r4
	sub	r10, r0, r2
	ldr	r0, [sp, #8]            @ 4-byte Reload
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI87_3
	mla	r4, r4, r9, r10
	ldr	r2, .LCPI87_4
.LPC87_1:
	add	r1, pc, r1
	add	r2, r2, r1
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r1, #6
	str	r1, [sp]
	ldr	r1, [sp, #12]           @ 4-byte Reload
	adds	r2, r7, r1
	mov	r1, r8
	adc	r3, r5, r4
	bl	halide_int64_to_string(PLT)
	cmp	r6, #0
	blt	.LBB87_34
@ BB#31:
	ldr	r1, .LCPI87_7
	ldr	r2, .LCPI87_8
.LPC87_3:
	add	r1, pc, r1
	add	r2, r2, r1
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	b	.LBB87_35
.LBB87_32:
	ldr	r0, .LCPI87_22
	ldr	r1, .LCPI87_23
.LPC87_11:
	add	r0, pc, r0
	b	.LBB87_37
.LBB87_33:
	ldr	r0, .LCPI87_10
	ldr	r1, .LCPI87_11
.LPC87_5:
	add	r0, pc, r0
	b	.LBB87_37
.LBB87_34:
	ldr	r1, .LCPI87_5
	ldr	r2, .LCPI87_6
.LPC87_2:
	add	r1, pc, r1
	add	r2, r2, r1
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	rsb	r6, r6, #0
.LBB87_35:
	mov	r1, #2
	asr	r3, r6, #31
	str	r1, [sp]
	mov	r1, r8
	mov	r2, r6
	b	.LBB87_51
.LBB87_36:
	ldr	r0, .LCPI87_14
	ldr	r1, .LCPI87_15
.LPC87_7:
	add	r0, pc, r0
.LBB87_37:
	add	r2, r1, r0
	mov	r0, r10
	mov	r1, r9
	bl	halide_string_to_string(PLT)
	b	.LBB87_52
.LBB87_38:
	vmov.i32	d0, #0x0
	mov	r0, r10
	mov	r1, r9
	mov	r2, #0
	bl	halide_double_to_string(PLT)
	b	.LBB87_52
.LBB87_39:
	mov	r0, #0
	mov	r6, r1
	str	r0, [sp, #12]           @ 4-byte Spill
	mov	r0, #0
	str	r0, [sp, #8]            @ 4-byte Spill
	b	.LBB87_42
.LBB87_40:
	movw	r0, #1075
	sub	r0, r0, r4
	lsr	r1, r7, r0
	rsb	r2, r0, #32
	orr	r5, r1, r3, lsl r2
	movw	r1, #1043
	sub	r1, r1, r4
	cmp	r1, #0
	lsrge	r5, r3, r1
	lsr	r4, r3, r0
	lsr	r2, r5, r2
	orr	r2, r2, r4, lsl r0
	lslge	r2, r5, r1
	subs	r7, r7, r5, lsl r0
	sbc	r3, r3, r2
.LBB87_41:
	mov	r0, r7
	mov	r1, r3
	str	r4, [sp, #4]            @ 4-byte Spill
	mov	r7, r5
	bl	__aeabi_ul2d(PLT)
	ldr	r3, [sp, #12]           @ 4-byte Reload
	movw	r2, #33920
	movt	r2, #16686
	vmov	d16, r0, r1
	add	r2, r2, r3, lsl #20
	vmov	d17, r6, r2
	vmul.f64	d16, d17, d16
	vmov.f64	d17, #5.000000e-01
	vadd.f64	d8, d16, d17
	vmov	r0, r1, d8
	bl	__aeabi_d2ulz(PLT)
	mov	r4, r0
	mov	r5, r1
	bl	__aeabi_ul2d(PLT)
	vmov	d16, r0, r1
	subs	r2, r4, #1
	vcmpe.f64	d16, d8
	sbc	r1, r5, #0
	mov	r0, #0
	vmrs	APSR_nzcv, fpscr
	movweq	r0, #1
	ands	r0, r4, r0
	moveq	r2, r4
	moveq	r1, r5
	eor	r0, r2, #576
	ldr	r5, [sp, #4]            @ 4-byte Reload
	eor	r0, r0, #999424
	orrs	r0, r0, r1
	moveq	r1, r0
	str	r1, [sp, #8]            @ 4-byte Spill
	mov	r1, r7
	adds	r7, r1, #1
	adc	r3, r5, #0
	cmp	r0, #0
	moveq	r2, r0
	movne	r3, r5
	movne	r7, r1
	str	r2, [sp, #12]           @ 4-byte Spill
.LBB87_42:
	mov	r0, #1
	mov	r2, r7
	str	r0, [sp]
	add	r0, sp, #16
	add	r5, r0, #480
	add	r1, r0, #512
	mov	r0, r5
	bl	halide_int64_to_string(PLT)
	cmp	r6, #1
	blt	.LBB87_50
@ BB#43:
	mvn	r1, #95
	mov	r12, #49
.LBB87_44:                              @ %.preheader
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB87_46 Depth 2
	mov	r3, r5
	mov	r5, r0
	cmp	r0, r3
	beq	.LBB87_49
@ BB#45:                                @   in Loop: Header=BB87_44 Depth=1
	sub	r7, r3, #1
	mov	r5, r0
	mov	r4, #0
.LBB87_46:                              @ %.lr.ph
                                        @   Parent Loop BB87_44 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrb	r2, [r5, #-1]!
	add	r2, r1, r2, lsl #1
	orr	r4, r2, r4
	sxtb	r2, r4
	cmp	r2, #9
	subgt	r4, r4, #10
	add	r4, r4, #48
	strb	r4, [r5]
	mov	r4, #0
	movwgt	r4, #1
	cmp	r3, r5
	bne	.LBB87_46
@ BB#47:                                @ %._crit_edge
                                        @   in Loop: Header=BB87_44 Depth=1
	mov	r5, r3
	cmp	r2, #9
	ble	.LBB87_49
@ BB#48:                                @   in Loop: Header=BB87_44 Depth=1
	mov	r5, r7
	strb	r12, [r7]
.LBB87_49:                              @ %._crit_edge.thread
                                        @   in Loop: Header=BB87_44 Depth=1
	add	r8, r8, #1
	cmp	r8, r6
	bne	.LBB87_44
.LBB87_50:                              @ %._crit_edge.16
	mov	r0, r10
	mov	r1, r9
	mov	r2, r5
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI87_9
	ldr	r2, .LCPI87_4
.LPC87_4:
	add	r1, pc, r1
	add	r2, r2, r1
	mov	r1, r9
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #12]           @ 4-byte Reload
	mov	r1, #6
	ldr	r3, [sp, #8]            @ 4-byte Reload
	str	r1, [sp]
	mov	r1, r9
.LBB87_51:
	bl	halide_int64_to_string(PLT)
.LBB87_52:
	sub	sp, r11, #40
	vpop	{d8}
	add	sp, sp, #4
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	3
@ BB#53:
.LCPI87_2:
	.long	0                       @ double 1.0E+6
	.long	1093567616
.LCPI87_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_0+8)
.LCPI87_1:
	.long	.L.str.8.94(GOTOFF)
.LCPI87_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_1+8)
.LCPI87_4:
	.long	.L.str.25.136(GOTOFF)
.LCPI87_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_2+8)
.LCPI87_6:
	.long	.L.str.11.97(GOTOFF)
.LCPI87_7:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_3+8)
.LCPI87_8:
	.long	.L.str.10.96(GOTOFF)
.LCPI87_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_4+8)
.LCPI87_10:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_5+8)
.LCPI87_11:
	.long	.L.str.5.91(GOTOFF)
.LCPI87_12:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_6+8)
.LCPI87_13:
	.long	.L.str.4.90(GOTOFF)
.LCPI87_14:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_7+8)
.LCPI87_15:
	.long	.L.str.7.93(GOTOFF)
.LCPI87_16:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_8+8)
.LCPI87_17:
	.long	.L.str.6.92(GOTOFF)
.LCPI87_18:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_9+8)
.LCPI87_19:
	.long	.L.str.1.87(GOTOFF)
.LCPI87_20:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_10+8)
.LCPI87_21:
	.long	.L.str.86(GOTOFF)
.LCPI87_22:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_11+8)
.LCPI87_23:
	.long	.L.str.3.89(GOTOFF)
.LCPI87_24:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC87_12+8)
.LCPI87_25:
	.long	.L.str.2.88(GOTOFF)
.Lfunc_end87:
	.size	halide_double_to_string, .Lfunc_end87-halide_double_to_string
	.cantunwind
	.fnend

	.section	.text.halide_pointer_to_string,"ax",%progbits
	.weak	halide_pointer_to_string
	.align	2
	.type	halide_pointer_to_string,%function
halide_pointer_to_string:               @ @halide_pointer_to_string
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	.pad	#24
	sub	sp, sp, #24
	vmov.i32	q8, #0x0
	mov	r5, sp
	mov	r12, r2
	mov	r2, r5
	mov	r3, #0
	add	lr, r5, #18
	vst1.64	{d16, d17}, [r2]!
	mov	r4, #1
	str	r3, [r2]
	add	r2, r5, #19
	ldr	r5, .LCPI88_0
	ldr	r6, .LCPI88_1
.LPC88_0:
	add	r5, pc, r5
	add	r5, r6, r5
.LBB88_1:                               @ =>This Inner Loop Header: Depth=1
	and	r6, r12, #15
	sub	r2, r2, #1
	ldrb	r6, [r5, r6]
	cmp	r4, #15
	strb	r6, [lr], #-1
	bgt	.LBB88_3
@ BB#2:                                 @   in Loop: Header=BB88_1 Depth=1
	lsr	r6, r12, #4
	add	r4, r4, #1
	orr	r12, r6, r3, lsl #28
	lsr	r3, r3, #4
	orrs	r6, r12, r3
	bne	.LBB88_1
.LBB88_3:
	mov	r3, #120
	strb	r3, [lr]
	mov	r3, #48
	strb	r3, [r2, #-2]!
	bl	halide_string_to_string(PLT)
	sub	sp, r11, #16
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI88_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC88_0+8)
.LCPI88_1:
	.long	.L.str.12.98(GOTOFF)
.Lfunc_end88:
	.size	halide_pointer_to_string, .Lfunc_end88-halide_pointer_to_string
	.cantunwind
	.fnend

	.section	.text.halide_get_device_handle,"ax",%progbits
	.weak	halide_get_device_handle
	.align	2
	.type	halide_get_device_handle,%function
halide_get_device_handle:               @ @halide_get_device_handle
	.fnstart
@ BB#0:
	mov	r2, #0
	cmp	r0, #0
	mov	r3, #0
	ldrdne	r2, r3, [r0]
	mov	r0, r2
	mov	r1, r3
	bx	lr
.Lfunc_end89:
	.size	halide_get_device_handle, .Lfunc_end89-halide_get_device_handle
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t
	.align	2
	.type	_ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t,%function
_ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t: @ @_ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r1
	mov	r5, r0
	ldrb	r1, [r4, #65]
	mov	r0, #0
	cmp	r1, #0
	beq	.LBB90_5
@ BB#1:
	ldrd	r0, r1, [r4]
	bl	halide_get_device_interface(PLT)
	ldrb	r2, [r4, #64]
	mov	r1, r0
	mvn	r0, #13
	cmp	r2, #0
	bne	.LBB90_5
@ BB#2:
	mvn	r0, #18
	cmp	r1, #0
	beq	.LBB90_5
@ BB#3:
	ldr	r2, [r1, #24]
	mov	r0, r5
	mov	r1, r4
	blx	r2
	cmp	r0, #0
	mvn	r0, #13
	bne	.LBB90_5
@ BB#4:
	mov	r0, #0
	strb	r0, [r4, #65]
.LBB90_5:
	pop	{r4, r5, r11, pc}
.Lfunc_end90:
	.size	_ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t, .Lfunc_end90-_ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t
	.cantunwind
	.fnend

	.section	.text.halide_get_device_interface,"ax",%progbits
	.weak	halide_get_device_interface
	.align	2
	.type	halide_get_device_interface,%function
halide_get_device_interface:            @ @halide_get_device_interface
	.fnstart
@ BB#0:
	orrs	r1, r0, r1
	mov	r1, #0
	ldrne	r1, [r0, #8]
	mov	r0, r1
	bx	lr
.Lfunc_end91:
	.size	halide_get_device_interface, .Lfunc_end91-halide_get_device_interface
	.cantunwind
	.fnend

	.section	.text.halide_new_device_wrapper,"ax",%progbits
	.weak	halide_new_device_wrapper
	.align	2
	.type	halide_new_device_wrapper,%function
halide_new_device_wrapper:              @ @halide_new_device_wrapper
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	mov	r7, r0
	mov	r0, #16
	mov	r6, r2
	mov	r8, r1
	bl	malloc(PLT)
	mov	r5, r0
	mov	r4, #0
	cmp	r5, #0
	beq	.LBB92_2
@ BB#1:
	stm	r5, {r7, r8}
	str	r6, [r5, #8]
	ldr	r0, [r6]
	blx	r0
	b	.LBB92_3
.LBB92_2:
	mov	r5, #0
.LBB92_3:
	mov	r0, r5
	mov	r1, r4
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
.Lfunc_end92:
	.size	halide_new_device_wrapper, .Lfunc_end92-halide_new_device_wrapper
	.cantunwind
	.fnend

	.section	.text.halide_delete_device_wrapper,"ax",%progbits
	.weak	halide_delete_device_wrapper
	.align	2
	.type	halide_delete_device_wrapper,%function
halide_delete_device_wrapper:           @ @halide_delete_device_wrapper
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	ldr	r0, [r4, #8]
	ldr	r0, [r0, #4]
	blx	r0
	mov	r0, r4
	pop	{r4, r10, r11, lr}
	b	free(PLT)
.Lfunc_end93:
	.size	halide_delete_device_wrapper, .Lfunc_end93-halide_delete_device_wrapper
	.cantunwind
	.fnend

	.section	.text.halide_device_release,"ax",%progbits
	.weak	halide_device_release
	.align	2
	.type	halide_device_release,%function
halide_device_release:                  @ @halide_device_release
	.fnstart
@ BB#0:
	ldr	r1, [r1, #20]
	bx	r1
.Lfunc_end94:
	.size	halide_device_release, .Lfunc_end94-halide_device_release
	.cantunwind
	.fnend

	.section	.text.halide_copy_to_host,"ax",%progbits
	.weak	halide_copy_to_host
	.align	2
	.type	halide_copy_to_host,%function
halide_copy_to_host:                    @ @halide_copy_to_host
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r1
	ldr	r1, .LCPI95_1
	mov	r5, r0
	ldr	r0, .LCPI95_0
.LPC95_0:
	add	r1, pc, r1
	ldr	r6, [r0, r1]
	mov	r0, r6
	bl	halide_mutex_lock(PLT)
	mov	r0, r5
	mov	r1, r4
	bl	_ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t(PLT)
	mov	r4, r0
	mov	r0, r6
	bl	halide_mutex_unlock(PLT)
	mov	r0, r4
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#1:
.LCPI95_0:
	.long	_ZN6Halide7Runtime8Internal17device_copy_mutexE(GOT)
.LCPI95_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC95_0+8)
.Lfunc_end95:
	.size	halide_copy_to_host, .Lfunc_end95-halide_copy_to_host
	.cantunwind
	.fnend

	.section	.text.halide_copy_to_device,"ax",%progbits
	.weak	halide_copy_to_device
	.align	2
	.type	halide_copy_to_device,%function
halide_copy_to_device:                  @ @halide_copy_to_device
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	mov	r5, r0
	ldr	r0, .LCPI96_1
	ldr	r8, .LCPI96_0
	mov	r6, r2
.LPC96_0:
	add	r0, pc, r0
	mov	r4, r1
	ldr	r0, [r8, r0]
	bl	halide_mutex_lock(PLT)
	ldrd	r0, r1, [r4]
	bl	halide_get_device_interface(PLT)
	cmp	r6, #0
	bne	.LBB96_2
@ BB#1:
	mvn	r7, #18
	mov	r6, r0
	cmp	r0, #0
	beq	.LBB96_16
.LBB96_2:
	ldrd	r2, r3, [r4]
	cmp	r0, r6
	orrsne	r1, r2, r3
	beq	.LBB96_10
@ BB#3:
	cmp	r0, #0
	beq	.LBB96_8
@ BB#4:
	ldrb	r0, [r4, #65]
	cmp	r0, #0
	beq	.LBB96_8
@ BB#5:
	ldrb	r0, [r4, #64]
	cmp	r0, #0
	beq	.LBB96_7
@ BB#6:
	ldr	r0, .LCPI96_2
	ldr	r1, .LCPI96_3
.LPC96_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r5
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB96_7:
	mov	r0, r5
	mov	r1, r4
	bl	_ZN6Halide7Runtime8Internal27copy_to_host_already_lockedEPvP8buffer_t(PLT)
	mov	r7, r0
	cmp	r7, #0
	bne	.LBB96_16
.LBB96_8:
	mov	r0, r5
	mov	r1, r4
	bl	halide_device_free(PLT)
	mov	r7, r0
	cmp	r7, #0
	bne	.LBB96_16
@ BB#9:
	mov	r0, #1
	strb	r0, [r4, #64]
	ldrd	r2, r3, [r4]
.LBB96_10:
	orrs	r0, r2, r3
	bne	.LBB96_12
@ BB#11:
	mov	r0, r5
	mov	r1, r4
	mov	r2, r6
	bl	halide_device_malloc(PLT)
	mov	r7, r0
	cmp	r7, #0
	bne	.LBB96_16
.LBB96_12:
	ldrb	r0, [r4, #64]
	mov	r7, #0
	cmp	r0, #0
	beq	.LBB96_16
@ BB#13:
	ldrb	r0, [r4, #65]
	cmp	r0, #0
	bne	.LBB96_16
@ BB#14:
	ldr	r2, [r6, #28]
	mov	r0, r5
	mov	r1, r4
	blx	r2
	mvn	r7, #14
	cmp	r0, #0
	bne	.LBB96_16
@ BB#15:
	mov	r7, #0
	strb	r7, [r4, #64]
.LBB96_16:
	ldr	r0, .LCPI96_4
.LPC96_2:
	add	r0, pc, r0
	ldr	r0, [r8, r0]
	bl	halide_mutex_unlock(PLT)
	mov	r0, r7
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
	.align	2
@ BB#17:
.LCPI96_0:
	.long	_ZN6Halide7Runtime8Internal17device_copy_mutexE(GOT)
.LCPI96_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC96_0+8)
.LCPI96_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC96_1+8)
.LCPI96_3:
	.long	.L.str.22.105(GOTOFF)
.LCPI96_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC96_2+8)
.Lfunc_end96:
	.size	halide_copy_to_device, .Lfunc_end96-halide_copy_to_device
	.cantunwind
	.fnend

	.section	.text.halide_device_free,"ax",%progbits
	.weak	halide_device_free
	.align	2
	.type	halide_device_free,%function
halide_device_free:                     @ @halide_device_free
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r11, lr}
	push	{r4, r5, r6, r7, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r1
	mov	r5, r0
	cmp	r4, #0
	beq	.LBB97_5
@ BB#1:
	ldrd	r6, r7, [r4]
	mov	r0, r6
	mov	r1, r7
	bl	halide_get_device_interface(PLT)
	mov	r0, r6
	mov	r1, r7
	bl	halide_get_device_interface(PLT)
	mov	r7, r0
	cmp	r7, #0
	beq	.LBB97_6
@ BB#2:
	ldr	r0, [r7]
	blx	r0
	ldr	r2, [r7, #12]
	mov	r0, r5
	mov	r1, r4
	blx	r2
	mov	r6, r0
	ldr	r0, [r7, #4]
	blx	r0
	ldrd	r0, r1, [r4]
	orrs	r0, r0, r1
	beq	.LBB97_4
@ BB#3:
	ldr	r0, .LCPI97_0
	ldr	r1, .LCPI97_1
.LPC97_0:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r5
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB97_4:
	cmp	r6, #0
	mvnne	r6, #17
	mov	r0, r6
	pop	{r4, r5, r6, r7, r11, pc}
.LBB97_5:
	mov	r0, #0
	mov	r1, #0
	bl	halide_get_device_interface(PLT)
.LBB97_6:                               @ %.thread
	mov	r6, #0
	mov	r0, r6
	strb	r6, [r4, #65]
	pop	{r4, r5, r6, r7, r11, pc}
	.align	2
@ BB#7:
.LCPI97_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC97_0+8)
.LCPI97_1:
	.long	.L.str.37(GOTOFF)
.Lfunc_end97:
	.size	halide_device_free, .Lfunc_end97-halide_device_free
	.cantunwind
	.fnend

	.section	.text.halide_device_malloc,"ax",%progbits
	.weak	halide_device_malloc
	.align	2
	.type	halide_device_malloc,%function
halide_device_malloc:                   @ @halide_device_malloc
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r6, r1
	mov	r4, r0
	ldrd	r0, r1, [r6]
	mov	r5, r2
	bl	halide_get_device_interface(PLT)
	cmp	r0, #0
	beq	.LBB98_4
@ BB#1:
	cmp	r0, r5
	beq	.LBB98_4
@ BB#2:
	mov	r0, r4
	mov	r1, #1024
	bl	halide_malloc(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB98_5
@ BB#3:
	ldr	r0, .LCPI98_0
	mov	r3, #0
	mov	r1, r5
	ldr	r2, .LCPI98_1
	strb	r3, [r1, #1023]!
.LPC98_0:
	add	r0, pc, r0
	add	r2, r2, r0
	mov	r0, r5
	bl	halide_string_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB98_6
.LBB98_4:
	ldr	r0, [r5]
	blx	r0
	ldr	r2, [r5, #8]
	mov	r0, r4
	mov	r1, r6
	blx	r2
	mov	r4, r0
	ldr	r0, [r5, #4]
	blx	r0
	cmp	r4, #0
	mvnne	r4, #15
	mov	r0, r4
	pop	{r4, r5, r6, r10, r11, pc}
.LBB98_5:
	ldr	r0, .LCPI98_2
	ldr	r1, .LCPI98_1
.LPC98_1:
	add	r6, pc, r0
	mov	r0, #0
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI98_3
	add	r1, r0, r6
	mov	r0, r4
.LBB98_6:                               @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r4, #15
	mov	r0, r4
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#7:
.LCPI98_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC98_0+8)
.LCPI98_1:
	.long	.L.str.34(GOTOFF)
.LCPI98_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC98_1+8)
.LCPI98_3:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end98:
	.size	halide_device_malloc, .Lfunc_end98-halide_device_malloc
	.cantunwind
	.fnend

	.section	.text.halide_device_sync,"ax",%progbits
	.weak	halide_device_sync
	.align	2
	.type	halide_device_sync,%function
halide_device_sync:                     @ @halide_device_sync
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r5, r1
	mov	r6, r0
	mvn	r4, #18
	cmp	r5, #0
	beq	.LBB99_3
@ BB#1:
	ldrd	r0, r1, [r5]
	bl	halide_get_device_interface(PLT)
	cmp	r0, #0
	beq	.LBB99_3
@ BB#2:
	ldr	r2, [r0, #16]
	mov	r0, r6
	mov	r1, r5
	blx	r2
	mov	r4, r0
	cmp	r4, #0
	mvnne	r4, #16
.LBB99_3:                               @ %.thread
	mov	r0, r4
	pop	{r4, r5, r6, r10, r11, pc}
.Lfunc_end99:
	.size	halide_device_sync, .Lfunc_end99-halide_device_sync
	.cantunwind
	.fnend

	.section	.text.halide_device_free_as_destructor,"ax",%progbits
	.weak	halide_device_free_as_destructor
	.align	2
	.type	halide_device_free_as_destructor,%function
halide_device_free_as_destructor:       @ @halide_device_free_as_destructor
	.fnstart
@ BB#0:
	b	halide_device_free(PLT)
.Lfunc_end100:
	.size	halide_device_free_as_destructor, .Lfunc_end100-halide_device_free_as_destructor
	.cantunwind
	.fnend

	.section	.text.halide_device_and_host_malloc,"ax",%progbits
	.weak	halide_device_and_host_malloc
	.align	2
	.type	halide_device_and_host_malloc,%function
halide_device_and_host_malloc:          @ @halide_device_and_host_malloc
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r6, r1
	mov	r4, r0
	ldrd	r0, r1, [r6]
	mov	r5, r2
	bl	halide_get_device_interface(PLT)
	cmp	r0, #0
	beq	.LBB101_4
@ BB#1:
	cmp	r0, r5
	beq	.LBB101_4
@ BB#2:
	mov	r0, r4
	mov	r1, #1024
	bl	halide_malloc(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB101_5
@ BB#3:
	ldr	r0, .LCPI101_0
	mov	r3, #0
	mov	r1, r5
	ldr	r2, .LCPI101_1
	strb	r3, [r1, #1023]!
.LPC101_0:
	add	r0, pc, r0
	add	r2, r2, r0
	mov	r0, r5
	bl	halide_string_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB101_6
.LBB101_4:
	ldr	r0, [r5]
	blx	r0
	ldr	r2, [r5, #32]
	mov	r0, r4
	mov	r1, r6
	blx	r2
	mov	r4, r0
	ldr	r0, [r5, #4]
	blx	r0
	cmp	r4, #0
	mvnne	r4, #15
	mov	r0, r4
	pop	{r4, r5, r6, r10, r11, pc}
.LBB101_5:
	ldr	r0, .LCPI101_2
	ldr	r1, .LCPI101_1
.LPC101_1:
	add	r6, pc, r0
	mov	r0, #0
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI101_3
	add	r1, r0, r6
	mov	r0, r4
.LBB101_6:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r4, #15
	mov	r0, r4
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#7:
.LCPI101_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC101_0+8)
.LCPI101_1:
	.long	.L.str.39.106(GOTOFF)
.LCPI101_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC101_1+8)
.LCPI101_3:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end101:
	.size	halide_device_and_host_malloc, .Lfunc_end101-halide_device_and_host_malloc
	.cantunwind
	.fnend

	.section	.text.halide_device_and_host_free,"ax",%progbits
	.weak	halide_device_and_host_free
	.align	2
	.type	halide_device_and_host_free,%function
halide_device_and_host_free:            @ @halide_device_and_host_free
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r11, lr}
	push	{r4, r5, r6, r7, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r1
	mov	r5, r0
	cmp	r4, #0
	beq	.LBB102_5
@ BB#1:
	ldrd	r6, r7, [r4]
	mov	r0, r6
	mov	r1, r7
	bl	halide_get_device_interface(PLT)
	mov	r0, r6
	mov	r1, r7
	bl	halide_get_device_interface(PLT)
	mov	r7, r0
	cmp	r7, #0
	beq	.LBB102_6
@ BB#2:
	ldr	r0, [r7]
	blx	r0
	ldr	r2, [r7, #36]
	mov	r0, r5
	mov	r1, r4
	blx	r2
	mov	r6, r0
	ldr	r0, [r7, #4]
	blx	r0
	ldrd	r0, r1, [r4]
	orrs	r0, r0, r1
	beq	.LBB102_4
@ BB#3:
	ldr	r0, .LCPI102_0
	ldr	r1, .LCPI102_1
.LPC102_0:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r5
	bl	halide_print(PLT)
	bl	abort(PLT)
.LBB102_4:
	cmp	r6, #0
	mvnne	r6, #17
	mov	r0, r6
	pop	{r4, r5, r6, r7, r11, pc}
.LBB102_5:
	mov	r0, #0
	mov	r1, #0
	bl	halide_get_device_interface(PLT)
.LBB102_6:                              @ %.thread
	mov	r6, #0
	mov	r0, r6
	strb	r6, [r4, #65]
	pop	{r4, r5, r6, r7, r11, pc}
	.align	2
@ BB#7:
.LCPI102_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC102_0+8)
.LCPI102_1:
	.long	.L.str.41(GOTOFF)
.Lfunc_end102:
	.size	halide_device_and_host_free, .Lfunc_end102-halide_device_and_host_free
	.cantunwind
	.fnend

	.section	.text.halide_default_device_and_host_malloc,"ax",%progbits
	.weak	halide_default_device_and_host_malloc
	.align	2
	.type	halide_default_device_and_host_malloc,%function
halide_default_device_and_host_malloc:  @ @halide_default_device_and_host_malloc
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r1
	mov	r5, r0
	mov	r0, r4
	mov	r6, r2
	bl	_ZN6Halide7Runtime8Internal8buf_sizeEPK8buffer_t(PLT)
	mov	r1, r0
	mov	r0, r5
	bl	halide_malloc(PLT)
	mov	r1, r0
	mvn	r0, #0
	str	r1, [r4, #8]
	cmp	r1, #0
	beq	.LBB103_3
@ BB#1:
	mov	r0, r5
	mov	r1, r4
	mov	r2, r6
	bl	halide_device_malloc(PLT)
	mov	r6, r0
	mov	r0, #0
	cmp	r6, #0
	beq	.LBB103_3
@ BB#2:
	ldr	r1, [r4, #8]
	mov	r0, r5
	bl	halide_free(PLT)
	mov	r0, #0
	str	r0, [r4, #8]
	mov	r0, r6
.LBB103_3:
	pop	{r4, r5, r6, r10, r11, pc}
.Lfunc_end103:
	.size	halide_default_device_and_host_malloc, .Lfunc_end103-halide_default_device_and_host_malloc
	.cantunwind
	.fnend

	.section	.text.halide_default_device_and_host_free,"ax",%progbits
	.weak	halide_default_device_and_host_free
	.align	2
	.type	halide_default_device_and_host_free,%function
halide_default_device_and_host_free:    @ @halide_default_device_and_host_free
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r1
	mov	r5, r0
	bl	halide_device_free(PLT)
	ldr	r1, [r4, #8]
	mov	r6, r0
	mov	r0, r5
	bl	halide_free(PLT)
	mov	r0, #0
	str	r0, [r4, #8]
	strh	r0, [r4, #64]
	mov	r0, r6
	pop	{r4, r5, r6, r10, r11, pc}
.Lfunc_end104:
	.size	halide_default_device_and_host_free, .Lfunc_end104-halide_default_device_and_host_free
	.cantunwind
	.fnend

	.section	.text.halide_device_and_host_free_as_destructor,"ax",%progbits
	.weak	halide_device_and_host_free_as_destructor
	.align	2
	.type	halide_device_and_host_free_as_destructor,%function
halide_device_and_host_free_as_destructor: @ @halide_device_and_host_free_as_destructor
	.fnstart
@ BB#0:
	b	halide_device_and_host_free(PLT)
.Lfunc_end105:
	.size	halide_device_and_host_free_as_destructor, .Lfunc_end105-halide_device_and_host_free_as_destructor
	.cantunwind
	.fnend

	.section	.text.halide_device_host_nop_free,"ax",%progbits
	.weak	halide_device_host_nop_free
	.align	2
	.type	halide_device_host_nop_free,%function
halide_device_host_nop_free:            @ @halide_device_host_nop_free
	.fnstart
@ BB#0:
	bx	lr
.Lfunc_end106:
	.size	halide_device_host_nop_free, .Lfunc_end106-halide_device_host_nop_free
	.cantunwind
	.fnend

	.section	.text.halide_runtime_internal_register_metadata,"ax",%progbits
	.weak	halide_runtime_internal_register_metadata
	.align	2
	.type	halide_runtime_internal_register_metadata,%function
halide_runtime_internal_register_metadata: @ @halide_runtime_internal_register_metadata
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	ldr	r1, .LCPI107_1
	mov	r4, r0
	ldr	r0, .LCPI107_0
.LPC107_0:
	add	r1, pc, r1
	ldr	r5, [r0, r1]
	mov	r0, r5
	bl	halide_mutex_lock(PLT)
	ldr	r0, [r5, #64]
	str	r0, [r4]
	mov	r0, r5
	str	r4, [r5, #64]
	pop	{r4, r5, r11, lr}
	b	halide_mutex_unlock(PLT)
	.align	2
@ BB#1:
.LCPI107_0:
	.long	_ZN6Halide7Runtime8Internal9list_headE(GOT)
.LCPI107_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC107_0+8)
.Lfunc_end107:
	.size	halide_runtime_internal_register_metadata, .Lfunc_end107-halide_runtime_internal_register_metadata
	.cantunwind
	.fnend

	.section	.text.halide_enumerate_registered_filters,"ax",%progbits
	.weak	halide_enumerate_registered_filters
	.align	2
	.type	halide_enumerate_registered_filters,%function
halide_enumerate_registered_filters:    @ @halide_enumerate_registered_filters
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	ldr	r0, .LCPI108_1
	mov	r4, r2
	ldr	r8, .LCPI108_0
	mov	r5, r1
.LPC108_0:
	add	r0, pc, r0
	ldr	r6, [r8, r0]
	mov	r0, r6
	bl	halide_mutex_lock(PLT)
	ldr	r7, [r6, #64]
	b	.LBB108_2
.LBB108_1:                              @   in Loop: Header=BB108_2 Depth=1
	ldr	r7, [r7]
.LBB108_2:                              @ =>This Inner Loop Header: Depth=1
	cmp	r7, #0
	beq	.LBB108_4
@ BB#3:                                 @ %.lr.ph
                                        @   in Loop: Header=BB108_2 Depth=1
	ldr	r0, [r7, #4]
	blx	r0
	ldr	r2, [r7, #8]
	mov	r1, r0
	mov	r0, r5
	blx	r4
	mov	r6, r0
	cmp	r6, #0
	beq	.LBB108_1
	b	.LBB108_5
.LBB108_4:
	mov	r6, #0
.LBB108_5:                              @ %._crit_edge
	ldr	r0, .LCPI108_2
.LPC108_1:
	add	r0, pc, r0
	ldr	r0, [r8, r0]
	bl	halide_mutex_unlock(PLT)
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
	.align	2
@ BB#6:
.LCPI108_0:
	.long	_ZN6Halide7Runtime8Internal9list_headE(GOT)
.LCPI108_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC108_0+8)
.LCPI108_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC108_1+8)
.Lfunc_end108:
	.size	halide_enumerate_registered_filters, .Lfunc_end108-halide_enumerate_registered_filters
	.cantunwind
	.fnend

	.section	.text.halide_float16_bits_to_float,"ax",%progbits
	.weak	halide_float16_bits_to_float
	.align	2
	.type	halide_float16_bits_to_float,%function
halide_float16_bits_to_float:           @ @halide_float16_bits_to_float
	.fnstart
@ BB#0:
	mov	r1, #-2147483648
	ubfx	r2, r0, #10, #5
	and	r1, r1, r0, lsl #16
	bfc	r0, #10, #22
	cmp	r0, #0
	beq	.LBB109_3
@ BB#1:
	cmp	r2, #0
	bne	.LBB109_3
@ BB#2:
	clz	r2, r0
	mov	r3, #864026624
	eor	r2, r2, #31
	mov	r12, #1
	add	r3, r3, r2, lsl #23
	bic	r0, r0, r12, lsl r2
	orr	r1, r3, r1
	rsb	r2, r2, #23
	orr	r0, r1, r0, lsl r2
	vmov	s0, r0
	bx	lr
.LBB109_3:
	lsl	r0, r0, #13
	mov	r3, #0
	cmp	r2, #0
	beq	.LBB109_7
@ BB#4:
	cmp	r2, #31
	bne	.LBB109_6
@ BB#5:
	movw	r3, #0
	movt	r3, #32640
	b	.LBB109_7
.LBB109_6:
	mov	r3, #939524096
	add	r3, r3, r2, lsl #23
.LBB109_7:
	orr	r0, r0, r1
	orr	r0, r0, r3
	vmov	s0, r0
	bx	lr
.Lfunc_end109:
	.size	halide_float16_bits_to_float, .Lfunc_end109-halide_float16_bits_to_float
	.cantunwind
	.fnend

	.section	.text.halide_float16_bits_to_double,"ax",%progbits
	.weak	halide_float16_bits_to_double
	.align	2
	.type	halide_float16_bits_to_double,%function
halide_float16_bits_to_double:          @ @halide_float16_bits_to_double
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	.setfp	r11, sp
	mov	r11, sp
	bl	halide_float16_bits_to_float(PLT)
	vcvt.f64.f32	d0, s0
	pop	{r11, pc}
.Lfunc_end110:
	.size	halide_float16_bits_to_double, .Lfunc_end110-halide_float16_bits_to_double
	.cantunwind
	.fnend

	.section	.text.halide_error_bounds_inference_call_failed,"ax",%progbits
	.weak	halide_error_bounds_inference_call_failed
	.align	2
	.type	halide_error_bounds_inference_call_failed,%function
halide_error_bounds_inference_call_failed: @ @halide_error_bounds_inference_call_failed
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	.pad	#8
	sub	sp, sp, #8
	mov	r8, r1
	mov	r1, #1024
	mov	r9, r2
	mov	r5, r0
	bl	halide_malloc(PLT)
	mov	r6, r0
	cmp	r6, #0
	beq	.LBB111_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r7, r6
	ldr	r0, .LCPI111_0
	strb	r2, [r7, #1023]!
.LPC111_0:
	add	r4, pc, r0
	mov	r0, r6
	ldr	r1, .LCPI111_1
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI111_2
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r9, #31
	str	r1, [sp]
	mov	r1, r7
	mov	r2, r9
	bl	halide_int64_to_string(PLT)
	mov	r0, r5
	mov	r1, r6
	b	.LBB111_3
.LBB111_2:                              @ %.critedge
	ldr	r0, .LCPI111_3
	ldr	r1, .LCPI111_1
.LPC111_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI111_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r9, #31
	str	r1, [sp]
	mov	r1, #0
	mov	r2, r9
	bl	halide_int64_to_string(PLT)
	ldr	r0, .LCPI111_4
	add	r1, r0, r7
	mov	r0, r5
.LBB111_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r5
	mov	r1, r6
	bl	halide_free(PLT)
	mov	r0, r9
	sub	sp, r11, #24
	pop	{r4, r5, r6, r7, r8, r9, r11, pc}
	.align	2
@ BB#4:
.LCPI111_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC111_0+8)
.LCPI111_1:
	.long	.L.str.111(GOTOFF)
.LCPI111_2:
	.long	.L.str.1.112(GOTOFF)
.LCPI111_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC111_1+8)
.LCPI111_4:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end111:
	.size	halide_error_bounds_inference_call_failed, .Lfunc_end111-halide_error_bounds_inference_call_failed
	.cantunwind
	.fnend

	.section	.text.halide_error_extern_stage_failed,"ax",%progbits
	.weak	halide_error_extern_stage_failed
	.align	2
	.type	halide_error_extern_stage_failed,%function
halide_error_extern_stage_failed:       @ @halide_error_extern_stage_failed
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	.pad	#8
	sub	sp, sp, #8
	mov	r8, r1
	mov	r1, #1024
	mov	r9, r2
	mov	r5, r0
	bl	halide_malloc(PLT)
	mov	r6, r0
	cmp	r6, #0
	beq	.LBB112_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r7, r6
	ldr	r0, .LCPI112_0
	strb	r2, [r7, #1023]!
.LPC112_0:
	add	r4, pc, r0
	mov	r0, r6
	ldr	r1, .LCPI112_1
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI112_2
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r9, #31
	str	r1, [sp]
	mov	r1, r7
	mov	r2, r9
	bl	halide_int64_to_string(PLT)
	mov	r0, r5
	mov	r1, r6
	b	.LBB112_3
.LBB112_2:                              @ %.critedge
	ldr	r0, .LCPI112_3
	ldr	r1, .LCPI112_1
.LPC112_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI112_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r9, #31
	str	r1, [sp]
	mov	r1, #0
	mov	r2, r9
	bl	halide_int64_to_string(PLT)
	ldr	r0, .LCPI112_4
	add	r1, r0, r7
	mov	r0, r5
.LBB112_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r5
	mov	r1, r6
	bl	halide_free(PLT)
	mov	r0, r9
	sub	sp, r11, #24
	pop	{r4, r5, r6, r7, r8, r9, r11, pc}
	.align	2
@ BB#4:
.LCPI112_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC112_0+8)
.LCPI112_1:
	.long	.L.str.2.113(GOTOFF)
.LCPI112_2:
	.long	.L.str.1.112(GOTOFF)
.LCPI112_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC112_1+8)
.LCPI112_4:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end112:
	.size	halide_error_extern_stage_failed, .Lfunc_end112-halide_error_extern_stage_failed
	.cantunwind
	.fnend

	.section	.text.halide_error_explicit_bounds_too_small,"ax",%progbits
	.weak	halide_error_explicit_bounds_too_small
	.align	2
	.type	halide_error_explicit_bounds_too_small,%function
halide_error_explicit_bounds_too_small: @ @halide_error_explicit_bounds_too_small
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#12
	sub	sp, sp, #12
	mov	r8, r1
	mov	r1, #1024
	mov	r7, r3
	mov	r9, r2
	str	r0, [sp, #8]            @ 4-byte Spill
	bl	halide_malloc(PLT)
	mov	r5, r0
	mov	r6, #0
	cmp	r5, #0
	beq	.LBB113_2
@ BB#1:
	mov	r0, #0
	mov	r6, r5
	strb	r0, [r6, #1023]!
.LBB113_2:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	ldr	r0, .LCPI113_0
	ldr	r1, .LCPI113_1
.LPC113_0:
	add	r10, pc, r0
	mov	r0, r5
	add	r2, r1, r10
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r6
	mov	r2, r9
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI113_2
	add	r2, r1, r10
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r6
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI113_3
	add	r2, r1, r10
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	asr	r3, r7, #31
	mov	r4, #1
	mov	r1, r6
	str	r4, [sp]
	mov	r2, r7
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI113_4
	add	r7, r1, r10
	mov	r1, r6
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, r6
	str	r4, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI113_5
	add	r2, r1, r10
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #12]
	mov	r1, r6
	str	r4, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	mov	r1, r6
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #16]
	mov	r1, r6
	str	r4, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI113_6
	add	r2, r1, r10
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	cmp	r5, #0
	beq	.LBB113_4
@ BB#3:
	ldr	r4, [sp, #8]            @ 4-byte Reload
	mov	r1, r5
	mov	r0, r4
	b	.LBB113_5
.LBB113_4:
	ldr	r0, .LCPI113_7
	ldr	r4, [sp, #8]            @ 4-byte Reload
	ldr	r1, .LCPI113_8
.LPC113_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r4
.LBB113_5:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #1
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#6:
.LCPI113_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC113_0+8)
.LCPI113_1:
	.long	.L.str.3.114(GOTOFF)
.LCPI113_2:
	.long	.L.str.4.115(GOTOFF)
.LCPI113_3:
	.long	.L.str.5.116(GOTOFF)
.LCPI113_4:
	.long	.L.str.6.117(GOTOFF)
.LCPI113_5:
	.long	.L.str.7.118(GOTOFF)
.LCPI113_6:
	.long	.L.str.8.119(GOTOFF)
.LCPI113_7:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC113_1+8)
.LCPI113_8:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end113:
	.size	halide_error_explicit_bounds_too_small, .Lfunc_end113-halide_error_explicit_bounds_too_small
	.cantunwind
	.fnend

	.section	.text.halide_error_bad_elem_size,"ax",%progbits
	.weak	halide_error_bad_elem_size
	.align	2
	.type	halide_error_bad_elem_size,%function
halide_error_bad_elem_size:             @ @halide_error_bad_elem_size
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r6, r1
	mov	r1, #1024
	mov	r7, r3
	mov	r10, r2
	mov	r9, r0
	bl	halide_malloc(PLT)
	ldr	r8, [r11, #8]
	mov	r5, r0
	mov	r0, #0
	cmp	r5, #0
	beq	.LBB114_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r4, r5
	mov	r2, r6
	strb	r0, [r4, #1023]!
	mov	r0, r5
	mov	r1, r4
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI114_0
	ldr	r2, .LCPI114_1
.LPC114_0:
	add	r6, pc, r1
	mov	r1, r4
	add	r2, r2, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r4
	mov	r2, r10
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI114_2
	add	r2, r1, r6
	mov	r1, r4
	bl	halide_string_to_string(PLT)
	asr	r3, r7, #31
	mov	r10, #1
	mov	r1, r4
	str	r10, [sp]
	mov	r2, r7
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI114_3
	add	r2, r1, r6
	mov	r1, r4
	bl	halide_string_to_string(PLT)
	asr	r3, r8, #31
	mov	r1, r4
	mov	r2, r8
	str	r10, [sp]
	bl	halide_int64_to_string(PLT)
	mov	r0, r9
	mov	r1, r5
	b	.LBB114_3
.LBB114_2:                              @ %.critedge
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI114_4
	ldr	r2, .LCPI114_1
.LPC114_1:
	add	r4, pc, r1
	mov	r1, #0
	add	r2, r2, r4
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r10
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI114_2
	add	r2, r1, r4
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	asr	r3, r7, #31
	mov	r6, #1
	mov	r1, #0
	str	r6, [sp]
	mov	r2, r7
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI114_3
	add	r2, r1, r4
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	asr	r3, r8, #31
	mov	r1, #0
	mov	r2, r8
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r0, .LCPI114_5
	add	r1, r0, r4
	mov	r0, r9
.LBB114_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r9
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #2
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI114_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC114_0+8)
.LCPI114_1:
	.long	.L.str.9.120(GOTOFF)
.LCPI114_2:
	.long	.L.str.10.121(GOTOFF)
.LCPI114_3:
	.long	.L.str.11.122(GOTOFF)
.LCPI114_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC114_1+8)
.LCPI114_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end114:
	.size	halide_error_bad_elem_size, .Lfunc_end114-halide_error_bad_elem_size
	.cantunwind
	.fnend

	.section	.text.halide_error_access_out_of_bounds,"ax",%progbits
	.weak	halide_error_access_out_of_bounds
	.align	2
	.type	halide_error_access_out_of_bounds,%function
halide_error_access_out_of_bounds:      @ @halide_error_access_out_of_bounds
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#12
	sub	sp, sp, #12
	ldr	r8, [r11, #12]
	mov	r5, r3
	mov	r4, r1
	mov	r6, r0
	cmp	r5, r8
	bge	.LBB115_5
@ BB#1:
	mov	r0, r6
	mov	r1, #1024
	str	r2, [sp, #8]            @ 4-byte Spill
	str	r6, [sp, #4]            @ 4-byte Spill
	bl	halide_malloc(PLT)
	mov	r6, r0
	mov	r7, #0
	mov	r9, #1
	cmp	r6, #0
	beq	.LBB115_3
@ BB#2:
	mov	r9, #0
	mov	r7, r6
	strb	r9, [r7, #1023]!
.LBB115_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r0, r6
	mov	r1, r7
	mov	r2, r4
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI115_6
	ldr	r2, .LCPI115_1
.LPC115_2:
	add	r4, pc, r1
	mov	r1, r7
	add	r2, r2, r4
	bl	halide_string_to_string(PLT)
	asr	r3, r5, #31
	mov	r10, #1
	mov	r1, r7
	str	r10, [sp]
	mov	r2, r5
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI115_7
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	asr	r3, r8, #31
	mov	r1, r7
	mov	r2, r8
	str	r10, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI115_3
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #8]            @ 4-byte Reload
	mov	r1, r7
	str	r10, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	cmp	r9, #1
	bne	.LBB115_10
@ BB#4:
	ldr	r0, .LCPI115_8
	ldr	r4, [sp, #4]            @ 4-byte Reload
	ldr	r1, .LCPI115_5
.LPC115_3:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r4
	b	.LBB115_11
.LBB115_5:
	ldr	r8, [r11, #16]
	ldr	r5, [r11, #8]
	cmp	r5, r8
	ble	.LBB115_15
@ BB#6:
	mov	r0, r6
	mov	r1, #1024
	str	r2, [sp, #8]            @ 4-byte Spill
	bl	halide_malloc(PLT)
	mov	r10, r0
	mov	r7, #0
	mov	r9, #1
	cmp	r10, #0
	beq	.LBB115_8
@ BB#7:
	mov	r9, #0
	mov	r7, r10
	strb	r9, [r7, #1023]!
.LBB115_8:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit1
	mov	r0, r10
	mov	r1, r7
	mov	r2, r4
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI115_0
	ldr	r2, .LCPI115_1
.LPC115_0:
	add	r4, pc, r1
	mov	r1, r7
	add	r2, r2, r4
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r5, #31
	str	r1, [sp]
	mov	r1, r7
	mov	r2, r5
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI115_2
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r8, #31
	str	r1, [sp]
	mov	r1, r7
	mov	r2, r8
	mov	r5, #1
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI115_3
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #8]            @ 4-byte Reload
	mov	r1, r7
	str	r5, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	cmp	r9, #1
	bne	.LBB115_12
@ BB#9:
	ldr	r0, .LCPI115_4
	ldr	r1, .LCPI115_5
.LPC115_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r6
	b	.LBB115_13
.LBB115_10:
	ldr	r4, [sp, #4]            @ 4-byte Reload
	mov	r1, r6
	mov	r0, r4
.LBB115_11:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r6
	b	.LBB115_14
.LBB115_12:
	mov	r0, r6
	mov	r1, r10
.LBB115_13:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit2
	bl	halide_error(PLT)
	mov	r0, r6
	mov	r1, r10
.LBB115_14:
	bl	halide_free(PLT)
.LBB115_15:
	mvn	r0, #3
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#16:
.LCPI115_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC115_0+8)
.LCPI115_1:
	.long	.L.str.12.123(GOTOFF)
.LCPI115_2:
	.long	.L.str.15.126(GOTOFF)
.LCPI115_3:
	.long	.L.str.14.125(GOTOFF)
.LCPI115_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC115_1+8)
.LCPI115_5:
	.long	.L.str.18.149(GOTOFF)
.LCPI115_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC115_2+8)
.LCPI115_7:
	.long	.L.str.13.124(GOTOFF)
.LCPI115_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC115_3+8)
.Lfunc_end115:
	.size	halide_error_access_out_of_bounds, .Lfunc_end115-halide_error_access_out_of_bounds
	.cantunwind
	.fnend

	.section	.text.halide_error_buffer_allocation_too_large,"ax",%progbits
	.weak	halide_error_buffer_allocation_too_large
	.align	2
	.type	halide_error_buffer_allocation_too_large,%function
halide_error_buffer_allocation_too_large: @ @halide_error_buffer_allocation_too_large
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r6, r1
	mov	r1, #1024
	mov	r10, r3
	mov	r9, r2
	mov	r4, r0
	bl	halide_malloc(PLT)
	ldr	r8, [r11, #12]
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB116_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r8, r5
	ldr	r0, .LCPI116_0
	strb	r2, [r8, #1023]!
.LPC116_0:
	add	r7, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI116_1
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r1, r8
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI116_2
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, r8
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r1, .LCPI116_3
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, r8
	ldr	r3, [r11, #12]
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB116_3
.LBB116_2:                              @ %.critedge
	ldr	r0, .LCPI116_4
	ldr	r1, .LCPI116_1
.LPC116_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI116_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, #0
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r1, .LCPI116_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, #0
	mov	r3, r8
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r0, .LCPI116_5
	add	r1, r0, r7
	mov	r0, r4
.LBB116_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #4
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI116_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC116_0+8)
.LCPI116_1:
	.long	.L.str.16.127(GOTOFF)
.LCPI116_2:
	.long	.L.str.17.128(GOTOFF)
.LCPI116_3:
	.long	.L.str.18.129(GOTOFF)
.LCPI116_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC116_1+8)
.LCPI116_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end116:
	.size	halide_error_buffer_allocation_too_large, .Lfunc_end116-halide_error_buffer_allocation_too_large
	.cantunwind
	.fnend

	.section	.text.halide_error_buffer_extents_too_large,"ax",%progbits
	.weak	halide_error_buffer_extents_too_large
	.align	2
	.type	halide_error_buffer_extents_too_large,%function
halide_error_buffer_extents_too_large:  @ @halide_error_buffer_extents_too_large
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r6, r1
	mov	r1, #1024
	mov	r10, r3
	mov	r9, r2
	mov	r4, r0
	bl	halide_malloc(PLT)
	ldr	r8, [r11, #12]
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB117_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r8, r5
	ldr	r0, .LCPI117_0
	strb	r2, [r8, #1023]!
.LPC117_0:
	add	r7, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI117_1
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r1, r8
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI117_2
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, r8
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI117_3
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, r8
	ldr	r3, [r11, #12]
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB117_3
.LBB117_2:                              @ %.critedge
	ldr	r0, .LCPI117_4
	ldr	r1, .LCPI117_1
.LPC117_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI117_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, #0
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI117_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, #0
	mov	r3, r8
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r0, .LCPI117_5
	add	r1, r0, r7
	mov	r0, r4
.LBB117_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #5
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI117_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC117_0+8)
.LCPI117_1:
	.long	.L.str.19.130(GOTOFF)
.LCPI117_2:
	.long	.L.str.17.128(GOTOFF)
.LCPI117_3:
	.long	.L.str.18.129(GOTOFF)
.LCPI117_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC117_1+8)
.LCPI117_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end117:
	.size	halide_error_buffer_extents_too_large, .Lfunc_end117-halide_error_buffer_extents_too_large
	.cantunwind
	.fnend

	.section	.text.halide_error_constraints_make_required_region_smaller,"ax",%progbits
	.weak	halide_error_constraints_make_required_region_smaller
	.align	2
	.type	halide_error_constraints_make_required_region_smaller,%function
halide_error_constraints_make_required_region_smaller: @ @halide_error_constraints_make_required_region_smaller
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#12
	sub	sp, sp, #12
	ldr	r2, [r11, #16]
	mov	r8, r3
	mov	r6, r1
	ldr	r3, [r11, #12]
	add	r1, r8, r2
	str	r0, [sp, #8]            @ 4-byte Spill
	sub	r1, r1, #1
	str	r1, [sp, #4]            @ 4-byte Spill
	add	r1, r3, r2
	sub	r4, r1, #1
	mov	r1, #1024
	bl	halide_malloc(PLT)
	mov	r5, r0
	mov	r7, #0
	cmp	r5, #0
	beq	.LBB118_2
@ BB#1:
	mov	r0, #0
	mov	r7, r5
	strb	r0, [r7, #1023]!
.LBB118_2:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	ldr	r0, .LCPI118_0
	ldr	r1, .LCPI118_1
.LPC118_0:
	add	r9, pc, r0
	mov	r0, r5
	add	r2, r1, r9
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI118_2
	add	r2, r1, r9
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI118_3
	add	r2, r1, r9
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #12]
	mov	r10, #1
	mov	r1, r7
	str	r10, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI118_4
	add	r6, r1, r9
	mov	r1, r7
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	asr	r3, r4, #31
	mov	r1, r7
	mov	r2, r4
	str	r10, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI118_5
	add	r2, r1, r9
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI118_6
	add	r2, r1, r9
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	asr	r3, r8, #31
	mov	r1, r7
	mov	r2, r8
	str	r10, [sp]
	bl	halide_int64_to_string(PLT)
	mov	r1, r7
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [sp, #4]            @ 4-byte Reload
	mov	r1, r7
	str	r10, [sp]
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI118_7
	add	r2, r1, r9
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	cmp	r5, #0
	beq	.LBB118_4
@ BB#3:
	ldr	r4, [sp, #8]            @ 4-byte Reload
	mov	r1, r5
	mov	r0, r4
	b	.LBB118_5
.LBB118_4:
	ldr	r0, .LCPI118_8
	ldr	r4, [sp, #8]            @ 4-byte Reload
	ldr	r1, .LCPI118_9
.LPC118_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r4
.LBB118_5:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #6
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#6:
.LCPI118_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC118_0+8)
.LCPI118_1:
	.long	.L.str.20.131(GOTOFF)
.LCPI118_2:
	.long	.L.str.21.132(GOTOFF)
.LCPI118_3:
	.long	.L.str.22.133(GOTOFF)
.LCPI118_4:
	.long	.L.str.6.117(GOTOFF)
.LCPI118_5:
	.long	.L.str.23.134(GOTOFF)
.LCPI118_6:
	.long	.L.str.24.135(GOTOFF)
.LCPI118_7:
	.long	.L.str.25.136(GOTOFF)
.LCPI118_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC118_1+8)
.LCPI118_9:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end118:
	.size	halide_error_constraints_make_required_region_smaller, .Lfunc_end118-halide_error_constraints_make_required_region_smaller
	.cantunwind
	.fnend

	.section	.text.halide_error_constraint_violated,"ax",%progbits
	.weak	halide_error_constraint_violated
	.align	2
	.type	halide_error_constraint_violated,%function
halide_error_constraint_violated:       @ @halide_error_constraint_violated
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#12
	sub	sp, sp, #12
	mov	r4, r1
	mov	r1, #1024
	str	r3, [sp, #8]            @ 4-byte Spill
	mov	r6, r2
	mov	r9, r0
	bl	halide_malloc(PLT)
	mov	r5, r0
	mov	r7, #0
	mov	r10, #1
	cmp	r5, #0
	beq	.LBB119_2
@ BB#1:
	mov	r10, #0
	mov	r7, r5
	strb	r10, [r7, #1023]!
.LBB119_2:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	ldr	r0, .LCPI119_0
	ldr	r1, .LCPI119_1
.LPC119_0:
	add	r8, pc, r0
	mov	r0, r5
	add	r2, r1, r8
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r4
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI119_2
	add	r4, r1, r8
	mov	r1, r7
	mov	r2, r4
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r6, #31
	str	r1, [sp]
	mov	r1, r7
	mov	r2, r6
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI119_3
	add	r2, r1, r8
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	ldr	r6, [sp, #8]            @ 4-byte Reload
	mov	r1, r7
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r4
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI119_4
	add	r2, r1, r8
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	cmp	r10, #1
	bne	.LBB119_4
@ BB#3:
	ldr	r0, .LCPI119_5
	ldr	r1, .LCPI119_6
.LPC119_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r9
	b	.LBB119_5
.LBB119_4:
	mov	r0, r9
	mov	r1, r5
.LBB119_5:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r9
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #7
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#6:
.LCPI119_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC119_0+8)
.LCPI119_1:
	.long	.L.str.26.137(GOTOFF)
.LCPI119_2:
	.long	.L.str.27.138(GOTOFF)
.LCPI119_3:
	.long	.L.str.28.139(GOTOFF)
.LCPI119_4:
	.long	.L.str.8.119(GOTOFF)
.LCPI119_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC119_1+8)
.LCPI119_6:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end119:
	.size	halide_error_constraint_violated, .Lfunc_end119-halide_error_constraint_violated
	.cantunwind
	.fnend

	.section	.text.halide_error_param_too_small_i64,"ax",%progbits
	.weak	halide_error_param_too_small_i64
	.align	2
	.type	halide_error_param_too_small_i64,%function
halide_error_param_too_small_i64:       @ @halide_error_param_too_small_i64
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r6, r1
	mov	r1, #1024
	mov	r10, r3
	mov	r9, r2
	mov	r4, r0
	bl	halide_malloc(PLT)
	ldr	r8, [r11, #12]
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB120_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r8, r5
	ldr	r0, .LCPI120_0
	strb	r2, [r8, #1023]!
.LPC120_0:
	add	r7, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI120_1
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r1, r8
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI120_2
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, r8
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI120_3
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, r8
	ldr	r3, [r11, #12]
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB120_3
.LBB120_2:                              @ %.critedge
	ldr	r0, .LCPI120_4
	ldr	r1, .LCPI120_1
.LPC120_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI120_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, #0
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI120_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, #0
	mov	r3, r8
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r0, .LCPI120_5
	add	r1, r0, r7
	mov	r0, r4
.LBB120_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #8
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI120_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC120_0+8)
.LCPI120_1:
	.long	.L.str.29.140(GOTOFF)
.LCPI120_2:
	.long	.L.str.17.128(GOTOFF)
.LCPI120_3:
	.long	.L.str.30(GOTOFF)
.LCPI120_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC120_1+8)
.LCPI120_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end120:
	.size	halide_error_param_too_small_i64, .Lfunc_end120-halide_error_param_too_small_i64
	.cantunwind
	.fnend

	.section	.text.halide_error_param_too_small_u64,"ax",%progbits
	.weak	halide_error_param_too_small_u64
	.align	2
	.type	halide_error_param_too_small_u64,%function
halide_error_param_too_small_u64:       @ @halide_error_param_too_small_u64
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r6, r1
	mov	r1, #1024
	mov	r10, r3
	mov	r9, r2
	mov	r4, r0
	bl	halide_malloc(PLT)
	ldr	r8, [r11, #12]
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB121_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r8, r5
	ldr	r0, .LCPI121_0
	strb	r2, [r8, #1023]!
.LPC121_0:
	add	r7, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI121_1
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r1, r8
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI121_2
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, r8
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r1, .LCPI121_3
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, r8
	ldr	r3, [r11, #12]
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB121_3
.LBB121_2:                              @ %.critedge
	ldr	r0, .LCPI121_4
	ldr	r1, .LCPI121_1
.LPC121_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI121_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, #0
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r1, .LCPI121_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, #0
	mov	r3, r8
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r0, .LCPI121_5
	add	r1, r0, r7
	mov	r0, r4
.LBB121_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #8
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI121_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC121_0+8)
.LCPI121_1:
	.long	.L.str.29.140(GOTOFF)
.LCPI121_2:
	.long	.L.str.17.128(GOTOFF)
.LCPI121_3:
	.long	.L.str.30(GOTOFF)
.LCPI121_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC121_1+8)
.LCPI121_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end121:
	.size	halide_error_param_too_small_u64, .Lfunc_end121-halide_error_param_too_small_u64
	.cantunwind
	.fnend

	.section	.text.halide_error_param_too_small_f64,"ax",%progbits
	.weak	halide_error_param_too_small_f64
	.align	2
	.type	halide_error_param_too_small_f64,%function
halide_error_param_too_small_f64:       @ @halide_error_param_too_small_f64
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	.vsave	{d8, d9}
	vpush	{d8, d9}
	mov	r6, r1
	mov	r1, #1024
	vmov.f64	d8, d1
	mov	r8, r0
	vmov.f64	d9, d0
	bl	halide_malloc(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB122_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r7, r5
	ldr	r0, .LCPI122_0
	strb	r2, [r7, #1023]!
.LPC122_0:
	add	r4, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI122_1
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI122_2
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	vmov.f64	d0, d9
	mov	r2, #1
	bl	halide_double_to_string(PLT)
	ldr	r1, .LCPI122_3
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	vmov.f64	d0, d8
	mov	r2, #1
	bl	halide_double_to_string(PLT)
	mov	r0, r8
	mov	r1, r5
	b	.LBB122_3
.LBB122_2:                              @ %.critedge
	ldr	r0, .LCPI122_4
	ldr	r1, .LCPI122_1
.LPC122_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI122_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	vmov.f64	d0, d9
	mov	r2, #1
	bl	halide_double_to_string(PLT)
	ldr	r1, .LCPI122_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	vmov.f64	d0, d8
	mov	r2, #1
	bl	halide_double_to_string(PLT)
	ldr	r0, .LCPI122_5
	add	r1, r0, r7
	mov	r0, r8
.LBB122_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r8
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #8
	vpop	{d8, d9}
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI122_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC122_0+8)
.LCPI122_1:
	.long	.L.str.29.140(GOTOFF)
.LCPI122_2:
	.long	.L.str.17.128(GOTOFF)
.LCPI122_3:
	.long	.L.str.30(GOTOFF)
.LCPI122_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC122_1+8)
.LCPI122_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end122:
	.size	halide_error_param_too_small_f64, .Lfunc_end122-halide_error_param_too_small_f64
	.cantunwind
	.fnend

	.section	.text.halide_error_param_too_large_i64,"ax",%progbits
	.weak	halide_error_param_too_large_i64
	.align	2
	.type	halide_error_param_too_large_i64,%function
halide_error_param_too_large_i64:       @ @halide_error_param_too_large_i64
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r6, r1
	mov	r1, #1024
	mov	r10, r3
	mov	r9, r2
	mov	r4, r0
	bl	halide_malloc(PLT)
	ldr	r8, [r11, #12]
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB123_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r8, r5
	ldr	r0, .LCPI123_0
	strb	r2, [r8, #1023]!
.LPC123_0:
	add	r7, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI123_1
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r1, r8
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI123_2
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, r8
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI123_3
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, r8
	ldr	r3, [r11, #12]
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB123_3
.LBB123_2:                              @ %.critedge
	ldr	r0, .LCPI123_4
	ldr	r1, .LCPI123_1
.LPC123_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI123_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, #0
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI123_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, #0
	mov	r3, r8
	str	r6, [sp]
	bl	halide_int64_to_string(PLT)
	ldr	r0, .LCPI123_5
	add	r1, r0, r7
	mov	r0, r4
.LBB123_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #9
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI123_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC123_0+8)
.LCPI123_1:
	.long	.L.str.29.140(GOTOFF)
.LCPI123_2:
	.long	.L.str.17.128(GOTOFF)
.LCPI123_3:
	.long	.L.str.31(GOTOFF)
.LCPI123_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC123_1+8)
.LCPI123_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end123:
	.size	halide_error_param_too_large_i64, .Lfunc_end123-halide_error_param_too_large_i64
	.cantunwind
	.fnend

	.section	.text.halide_error_param_too_large_u64,"ax",%progbits
	.weak	halide_error_param_too_large_u64
	.align	2
	.type	halide_error_param_too_large_u64,%function
halide_error_param_too_large_u64:       @ @halide_error_param_too_large_u64
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r6, r1
	mov	r1, #1024
	mov	r10, r3
	mov	r9, r2
	mov	r4, r0
	bl	halide_malloc(PLT)
	ldr	r8, [r11, #12]
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB124_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r8, r5
	ldr	r0, .LCPI124_0
	strb	r2, [r8, #1023]!
.LPC124_0:
	add	r7, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI124_1
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r1, r8
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI124_2
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, r8
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r1, .LCPI124_3
	add	r2, r1, r7
	mov	r1, r8
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, r8
	ldr	r3, [r11, #12]
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB124_3
.LBB124_2:                              @ %.critedge
	ldr	r0, .LCPI124_4
	ldr	r1, .LCPI124_1
.LPC124_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI124_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r6, #1
	mov	r1, #0
	mov	r2, r9
	mov	r3, r10
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r1, .LCPI124_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, #0
	mov	r3, r8
	str	r6, [sp]
	bl	halide_uint64_to_string(PLT)
	ldr	r0, .LCPI124_5
	add	r1, r0, r7
	mov	r0, r4
.LBB124_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #9
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI124_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC124_0+8)
.LCPI124_1:
	.long	.L.str.29.140(GOTOFF)
.LCPI124_2:
	.long	.L.str.17.128(GOTOFF)
.LCPI124_3:
	.long	.L.str.31(GOTOFF)
.LCPI124_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC124_1+8)
.LCPI124_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end124:
	.size	halide_error_param_too_large_u64, .Lfunc_end124-halide_error_param_too_large_u64
	.cantunwind
	.fnend

	.section	.text.halide_error_param_too_large_f64,"ax",%progbits
	.weak	halide_error_param_too_large_f64
	.align	2
	.type	halide_error_param_too_large_f64,%function
halide_error_param_too_large_f64:       @ @halide_error_param_too_large_f64
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	.vsave	{d8, d9}
	vpush	{d8, d9}
	mov	r6, r1
	mov	r1, #1024
	vmov.f64	d8, d1
	mov	r8, r0
	vmov.f64	d9, d0
	bl	halide_malloc(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB125_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r7, r5
	ldr	r0, .LCPI125_0
	strb	r2, [r7, #1023]!
.LPC125_0:
	add	r4, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI125_1
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI125_2
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	vmov.f64	d0, d9
	mov	r2, #1
	bl	halide_double_to_string(PLT)
	ldr	r1, .LCPI125_3
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	vmov.f64	d0, d8
	mov	r2, #1
	bl	halide_double_to_string(PLT)
	mov	r0, r8
	mov	r1, r5
	b	.LBB125_3
.LBB125_2:                              @ %.critedge
	ldr	r0, .LCPI125_4
	ldr	r1, .LCPI125_1
.LPC125_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI125_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	vmov.f64	d0, d9
	mov	r2, #1
	bl	halide_double_to_string(PLT)
	ldr	r1, .LCPI125_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	vmov.f64	d0, d8
	mov	r2, #1
	bl	halide_double_to_string(PLT)
	ldr	r0, .LCPI125_5
	add	r1, r0, r7
	mov	r0, r8
.LBB125_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r8
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #9
	vpop	{d8, d9}
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI125_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC125_0+8)
.LCPI125_1:
	.long	.L.str.29.140(GOTOFF)
.LCPI125_2:
	.long	.L.str.17.128(GOTOFF)
.LCPI125_3:
	.long	.L.str.31(GOTOFF)
.LCPI125_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC125_1+8)
.LCPI125_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end125:
	.size	halide_error_param_too_large_f64, .Lfunc_end125-halide_error_param_too_large_f64
	.cantunwind
	.fnend

	.section	.text.halide_error_out_of_memory,"ax",%progbits
	.weak	halide_error_out_of_memory
	.align	2
	.type	halide_error_out_of_memory,%function
halide_error_out_of_memory:             @ @halide_error_out_of_memory
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	.setfp	r11, sp
	mov	r11, sp
	ldr	r1, .LCPI126_0
	ldr	r2, .LCPI126_1
.LPC126_0:
	add	r1, pc, r1
	add	r1, r2, r1
	bl	halide_error(PLT)
	mvn	r0, #10
	pop	{r11, pc}
	.align	2
@ BB#1:
.LCPI126_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC126_0+8)
.LCPI126_1:
	.long	.L.str.32(GOTOFF)
.Lfunc_end126:
	.size	halide_error_out_of_memory, .Lfunc_end126-halide_error_out_of_memory
	.cantunwind
	.fnend

	.section	.text.halide_error_buffer_argument_is_null,"ax",%progbits
	.weak	halide_error_buffer_argument_is_null
	.align	2
	.type	halide_error_buffer_argument_is_null,%function
halide_error_buffer_argument_is_null:   @ @halide_error_buffer_argument_is_null
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	mov	r8, r1
	mov	r1, #1024
	mov	r4, r0
	bl	halide_malloc(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB127_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r7, r5
	ldr	r0, .LCPI127_0
	strb	r2, [r7, #1023]!
.LPC127_0:
	add	r6, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI127_1
	add	r2, r1, r6
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI127_2
	add	r2, r1, r6
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r0, r4
	mov	r1, r5
	b	.LBB127_3
.LBB127_2:                              @ %.critedge
	ldr	r0, .LCPI127_3
	ldr	r1, .LCPI127_1
.LPC127_1:
	add	r6, pc, r0
	mov	r0, #0
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI127_2
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI127_4
	add	r1, r0, r6
	mov	r0, r4
.LBB127_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #11
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI127_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC127_0+8)
.LCPI127_1:
	.long	.L.str.33(GOTOFF)
.LCPI127_2:
	.long	.L.str.34.141(GOTOFF)
.LCPI127_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC127_1+8)
.LCPI127_4:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end127:
	.size	halide_error_buffer_argument_is_null, .Lfunc_end127-halide_error_buffer_argument_is_null
	.cantunwind
	.fnend

	.section	.text.halide_error_debug_to_file_failed,"ax",%progbits
	.weak	halide_error_debug_to_file_failed
	.align	2
	.type	halide_error_debug_to_file_failed,%function
halide_error_debug_to_file_failed:      @ @halide_error_debug_to_file_failed
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r6, r1
	mov	r1, #1024
	mov	r9, r3
	mov	r8, r2
	mov	r10, r0
	bl	halide_malloc(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB128_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r7, r5
	ldr	r0, .LCPI128_0
	strb	r2, [r7, #1023]!
.LPC128_0:
	add	r4, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI128_1
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI128_2
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, r7
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI128_3
	add	r2, r1, r4
	mov	r1, r7
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r9, #31
	str	r1, [sp]
	mov	r1, r7
	mov	r2, r9
	bl	halide_int64_to_string(PLT)
	mov	r0, r10
	mov	r1, r5
	b	.LBB128_3
.LBB128_2:                              @ %.critedge
	ldr	r0, .LCPI128_4
	ldr	r1, .LCPI128_1
.LPC128_1:
	add	r7, pc, r0
	mov	r0, #0
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI128_2
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI128_3
	add	r2, r1, r7
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r9, #31
	str	r1, [sp]
	mov	r1, #0
	mov	r2, r9
	bl	halide_int64_to_string(PLT)
	ldr	r0, .LCPI128_5
	add	r1, r0, r7
	mov	r0, r10
.LBB128_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r10
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #12
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI128_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC128_0+8)
.LCPI128_1:
	.long	.L.str.35(GOTOFF)
.LCPI128_2:
	.long	.L.str.36(GOTOFF)
.LCPI128_3:
	.long	.L.str.37.142(GOTOFF)
.LCPI128_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC128_1+8)
.LCPI128_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end128:
	.size	halide_error_debug_to_file_failed, .Lfunc_end128-halide_error_debug_to_file_failed
	.cantunwind
	.fnend

	.section	.text.halide_error_unaligned_host_ptr,"ax",%progbits
	.weak	halide_error_unaligned_host_ptr
	.align	2
	.type	halide_error_unaligned_host_ptr,%function
halide_error_unaligned_host_ptr:        @ @halide_error_unaligned_host_ptr
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	.pad	#8
	sub	sp, sp, #8
	mov	r7, r1
	mov	r1, #1024
	mov	r9, r2
	mov	r8, r0
	bl	halide_malloc(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB129_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r4, r5
	ldr	r0, .LCPI129_0
	strb	r2, [r4, #1023]!
.LPC129_0:
	add	r6, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI129_1
	add	r2, r1, r6
	mov	r1, r4
	bl	halide_string_to_string(PLT)
	mov	r1, r4
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI129_2
	add	r2, r1, r6
	mov	r1, r4
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r9, #31
	str	r1, [sp]
	mov	r1, r4
	mov	r2, r9
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI129_3
	add	r2, r1, r6
	mov	r1, r4
	bl	halide_string_to_string(PLT)
	mov	r0, r8
	mov	r1, r5
	b	.LBB129_3
.LBB129_2:                              @ %.critedge
	ldr	r0, .LCPI129_4
	ldr	r1, .LCPI129_1
.LPC129_1:
	add	r4, pc, r0
	mov	r0, #0
	add	r2, r1, r4
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI129_2
	add	r2, r1, r4
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r9, #31
	str	r1, [sp]
	mov	r1, #0
	mov	r2, r9
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI129_3
	add	r2, r1, r4
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI129_5
	add	r1, r0, r4
	mov	r0, r8
.LBB129_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r8
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #23
	sub	sp, r11, #24
	pop	{r4, r5, r6, r7, r8, r9, r11, pc}
	.align	2
@ BB#4:
.LCPI129_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC129_0+8)
.LCPI129_1:
	.long	.L.str.38(GOTOFF)
.LCPI129_2:
	.long	.L.str.39.143(GOTOFF)
.LCPI129_3:
	.long	.L.str.40(GOTOFF)
.LCPI129_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC129_1+8)
.LCPI129_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end129:
	.size	halide_error_unaligned_host_ptr, .Lfunc_end129-halide_error_unaligned_host_ptr
	.cantunwind
	.fnend

	.section	.text.halide_error_bad_fold,"ax",%progbits
	.weak	halide_error_bad_fold
	.align	2
	.type	halide_error_bad_fold,%function
halide_error_bad_fold:                  @ @halide_error_bad_fold
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r9, r1
	mov	r1, #1024
	mov	r8, r3
	mov	r7, r2
	mov	r10, r0
	bl	halide_malloc(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB130_2
@ BB#1:                                 @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	mov	r2, #0
	mov	r6, r5
	ldr	r0, .LCPI130_0
	strb	r2, [r6, #1023]!
.LPC130_0:
	add	r4, pc, r0
	mov	r0, r5
	ldr	r1, .LCPI130_1
	add	r2, r1, r4
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r6
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI130_2
	add	r2, r1, r4
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r6
	mov	r2, r9
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI130_3
	add	r2, r1, r4
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r6
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI130_4
	add	r2, r1, r4
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r0, r10
	mov	r1, r5
	b	.LBB130_3
.LBB130_2:                              @ %.critedge
	ldr	r0, .LCPI130_5
	ldr	r1, .LCPI130_1
.LPC130_1:
	add	r6, pc, r0
	mov	r0, #0
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI130_2
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r9
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI130_3
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #0
	mov	r2, r8
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI130_4
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI130_6
	add	r1, r0, r6
	mov	r0, r10
.LBB130_3:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r10
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #24
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#4:
.LCPI130_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC130_0+8)
.LCPI130_1:
	.long	.L.str.41.144(GOTOFF)
.LCPI130_2:
	.long	.L.str.42.145(GOTOFF)
.LCPI130_3:
	.long	.L.str.43(GOTOFF)
.LCPI130_4:
	.long	.L.str.25.136(GOTOFF)
.LCPI130_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC130_1+8)
.LCPI130_6:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end130:
	.size	halide_error_bad_fold, .Lfunc_end130-halide_error_bad_fold
	.cantunwind
	.fnend

	.section	.text.halide_error_fold_factor_too_small,"ax",%progbits
	.weak	halide_error_fold_factor_too_small
	.align	2
	.type	halide_error_fold_factor_too_small,%function
halide_error_fold_factor_too_small:     @ @halide_error_fold_factor_too_small
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#4
	sub	sp, sp, #4
	mov	r10, r1
	mov	r1, #1024
	mov	r8, r3
	mov	r7, r2
	mov	r4, r0
	bl	halide_malloc(PLT)
	mov	r5, r0
	mov	r6, #0
	cmp	r5, #0
	beq	.LBB131_2
@ BB#1:
	mov	r0, #0
	mov	r6, r5
	strb	r0, [r6, #1023]!
.LBB131_2:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit
	ldr	r0, .LCPI131_0
	ldr	r1, .LCPI131_1
.LPC131_0:
	add	r9, pc, r0
	mov	r0, r5
	add	r2, r1, r9
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r8, #31
	str	r1, [sp]
	mov	r1, r6
	mov	r2, r8
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI131_2
	add	r2, r1, r9
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r6
	mov	r2, r7
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI131_3
	add	r2, r1, r9
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, r6
	mov	r2, r10
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI131_4
	add	r2, r1, r9
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #8]
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r1, .LCPI131_5
	add	r2, r1, r9
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	ldr	r2, [r11, #12]
	mov	r1, #1
	str	r1, [sp]
	mov	r1, r6
	asr	r3, r2, #31
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI131_6
	add	r2, r1, r9
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	cmp	r5, #0
	beq	.LBB131_4
@ BB#3:
	mov	r0, r4
	mov	r1, r5
	b	.LBB131_5
.LBB131_4:
	ldr	r0, .LCPI131_7
	ldr	r1, .LCPI131_8
.LPC131_1:
	add	r0, pc, r0
	add	r1, r1, r0
	mov	r0, r4
.LBB131_5:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, r4
	mov	r1, r5
	bl	halide_free(PLT)
	mvn	r0, #25
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#6:
.LCPI131_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC131_0+8)
.LCPI131_1:
	.long	.L.str.44(GOTOFF)
.LCPI131_2:
	.long	.L.str.45(GOTOFF)
.LCPI131_3:
	.long	.L.str.42.145(GOTOFF)
.LCPI131_4:
	.long	.L.str.46(GOTOFF)
.LCPI131_5:
	.long	.L.str.27.138(GOTOFF)
.LCPI131_6:
	.long	.L.str.47(GOTOFF)
.LCPI131_7:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC131_1+8)
.LCPI131_8:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end131:
	.size	halide_error_fold_factor_too_small, .Lfunc_end131-halide_error_fold_factor_too_small
	.cantunwind
	.fnend

	.section	.text.halide_default_can_use_target_features,"ax",%progbits
	.weak	halide_default_can_use_target_features
	.align	2
	.type	halide_default_can_use_target_features,%function
halide_default_can_use_target_features: @ @halide_default_can_use_target_features
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r11, lr}
	push	{r4, r5, r6, r7, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	.pad	#16
	sub	sp, sp, #16
	mov	r4, r0
	ldr	r0, .LCPI132_1
	ldr	r7, .LCPI132_0
	mov	r5, r1
.LPC132_0:
	add	r0, pc, r0
	ldrb	r0, [r7, r0]
	cmp	r0, #0
	bne	.LBB132_2
@ BB#1:
	mov	r6, sp
	mov	r0, r6
	bl	_ZN6Halide7Runtime8Internal23halide_get_cpu_featuresEv(PLT)
	ldr	r0, .LCPI132_2
	vld1.64	{d16, d17}, [r6]
.LPC132_1:
	add	r0, pc, r0
	add	r1, r7, r0
	add	r1, r1, #16
	vst1.64	{d16, d17}, [r1]
	mov	r1, #1
	strb	r1, [r7, r0]
.LBB132_2:
	ldr	r0, .LCPI132_3
.LPC132_2:
	add	r0, pc, r0
	add	r0, r7, r0
	ldrd	r0, r1, [r0, #16]
	and	r1, r1, r5
	and	r0, r0, r4
	orrs	r2, r0, r1
	beq	.LBB132_4
@ BB#3:
	ldr	r2, .LCPI132_4
.LPC132_3:
	add	r2, pc, r2
	add	r2, r7, r2
	ldrd	r2, r3, [r2, #24]
	bic	r1, r1, r3
	bic	r0, r0, r2
	orrs	r0, r0, r1
	mov	r0, #0
	moveq	r0, #1
	b	.LBB132_5
.LBB132_4:
	mov	r0, #1
.LBB132_5:
	sub	sp, r11, #16
	pop	{r4, r5, r6, r7, r11, pc}
	.align	2
@ BB#6:
.LCPI132_0:
	.long	_MergedGlobals(GOTOFF)
.LCPI132_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC132_0+8)
.LCPI132_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC132_1+8)
.LCPI132_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC132_2+8)
.LCPI132_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC132_3+8)
.Lfunc_end132:
	.size	halide_default_can_use_target_features, .Lfunc_end132-halide_default_can_use_target_features
	.cantunwind
	.fnend

	.section	.text.halide_set_custom_can_use_target_features,"ax",%progbits
	.weak	halide_set_custom_can_use_target_features
	.align	2
	.type	halide_set_custom_can_use_target_features,%function
halide_set_custom_can_use_target_features: @ @halide_set_custom_can_use_target_features
	.fnstart
@ BB#0:
	ldr	r2, .LCPI133_1
	ldr	r1, .LCPI133_0
.LPC133_0:
	add	r2, pc, r2
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	str	r0, [r2]
	mov	r0, r1
	bx	lr
	.align	2
@ BB#1:
.LCPI133_0:
	.long	_ZN6Halide7Runtime8Internal30custom_can_use_target_featuresE(GOT)
.LCPI133_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC133_0+8)
.Lfunc_end133:
	.size	halide_set_custom_can_use_target_features, .Lfunc_end133-halide_set_custom_can_use_target_features
	.cantunwind
	.fnend

	.section	.text.halide_can_use_target_features,"ax",%progbits
	.weak	halide_can_use_target_features
	.align	2
	.type	halide_can_use_target_features,%function
halide_can_use_target_features:         @ @halide_can_use_target_features
	.fnstart
@ BB#0:
	ldr	r3, .LCPI134_1
	ldr	r2, .LCPI134_0
.LPC134_0:
	add	r3, pc, r3
	ldr	r2, [r2, r3]
	ldr	r2, [r2]
	bx	r2
	.align	2
@ BB#1:
.LCPI134_0:
	.long	_ZN6Halide7Runtime8Internal30custom_can_use_target_featuresE(GOT)
.LCPI134_1:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC134_0+8)
.Lfunc_end134:
	.size	halide_can_use_target_features, .Lfunc_end134-halide_can_use_target_features
	.cantunwind
	.fnend

	.section	.text._ZN6Halide7Runtime8Internal23halide_get_cpu_featuresEv,"ax",%progbits
	.weak	_ZN6Halide7Runtime8Internal23halide_get_cpu_featuresEv
	.align	2
	.type	_ZN6Halide7Runtime8Internal23halide_get_cpu_featuresEv,%function
_ZN6Halide7Runtime8Internal23halide_get_cpu_featuresEv: @ @_ZN6Halide7Runtime8Internal23halide_get_cpu_featuresEv
	.fnstart
@ BB#0:
	vmov.i32	q8, #0x0
	vst1.64	{d16, d17}, [r0]
	bx	lr
.Lfunc_end135:
	.size	_ZN6Halide7Runtime8Internal23halide_get_cpu_featuresEv, .Lfunc_end135-_ZN6Halide7Runtime8Internal23halide_get_cpu_featuresEv
	.cantunwind
	.fnend

	.section	.text.halide_zynq_init,"ax",%progbits
	.weak	halide_zynq_init
	.align	2
	.type	halide_zynq_init,%function
halide_zynq_init:                       @ @halide_zynq_init
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	ldr	r0, .LCPI136_0
	ldr	r5, .LCPI136_1
.LPC136_0:
	add	r0, pc, r0
	add	r0, r5, r0
	ldr	r1, [r0, #4]
	ldr	r0, [r0, #8]
	orrs	r0, r0, r1
	beq	.LBB136_3
@ BB#1:
	mov	r0, #0
	mov	r1, #1024
	mov	r5, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB136_7
@ BB#2:
	ldr	r0, .LCPI136_2
	mov	r1, r4
	ldr	r2, .LCPI136_3
	strb	r5, [r1, #1023]!
.LPC136_1:
	add	r0, pc, r0
	add	r2, r2, r0
	mov	r0, r4
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB136_8
.LBB136_3:
	ldr	r0, .LCPI136_6
	mov	r2, #420
	ldr	r1, .LCPI136_7
.LPC136_3:
	add	r4, pc, r0
	add	r0, r1, r4
	mov	r1, #2
	bl	open(PLT)
	add	r1, r5, r4
	cmn	r0, #1
	str	r0, [r1, #4]
	beq	.LBB136_9
@ BB#4:
	ldr	r0, .LCPI136_8
	mov	r2, #420
	ldr	r1, .LCPI136_9
.LPC136_4:
	add	r4, pc, r0
	add	r0, r1, r4
	mov	r1, #2
	bl	open(PLT)
	mov	r1, r0
	add	r0, r5, r4
	str	r1, [r0, #8]
	mov	r0, #0
	cmn	r1, #1
	bne	.LBB136_16
@ BB#5:
	mov	r0, #0
	mov	r1, #1024
	mov	r6, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB136_13
@ BB#6:
	ldr	r0, .LCPI136_10
	mov	r1, r4
	ldr	r2, .LCPI136_11
	strb	r6, [r1, #1023]!
.LPC136_5:
	add	r0, pc, r0
	add	r2, r2, r0
	mov	r0, r4
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB136_14
.LBB136_7:
	ldr	r0, .LCPI136_4
	ldr	r1, .LCPI136_3
.LPC136_2:
	add	r5, pc, r0
	mov	r0, #0
	add	r2, r1, r5
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI136_5
	add	r1, r0, r5
	mov	r0, #0
.LBB136_8:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit2
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	mvn	r0, #0
	pop	{r4, r5, r6, r10, r11, pc}
.LBB136_9:
	mov	r0, #0
	mov	r1, #1024
	mov	r6, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB136_11
@ BB#10:
	ldr	r0, .LCPI136_14
	mov	r1, r4
	ldr	r2, .LCPI136_15
	strb	r6, [r1, #1023]!
.LPC136_8:
	add	r0, pc, r0
	add	r2, r2, r0
	mov	r0, r4
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB136_12
.LBB136_11:
	ldr	r0, .LCPI136_16
	ldr	r1, .LCPI136_15
.LPC136_9:
	add	r6, pc, r0
	mov	r0, #0
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI136_5
	add	r1, r0, r6
	mov	r0, #0
.LBB136_12:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit4
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	mov	r6, #0
	bl	halide_free(PLT)
	ldr	r0, .LCPI136_17
.LPC136_10:
	add	r0, pc, r0
	add	r0, r5, r0
	str	r6, [r0, #4]
	str	r6, [r0, #8]
	b	.LBB136_15
.LBB136_13:
	ldr	r0, .LCPI136_12
	ldr	r1, .LCPI136_11
.LPC136_6:
	add	r6, pc, r0
	mov	r0, #0
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI136_5
	add	r1, r0, r6
	mov	r0, #0
.LBB136_14:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	mov	r6, #0
	bl	halide_free(PLT)
	ldr	r0, .LCPI136_13
.LPC136_7:
	add	r0, pc, r0
	add	r4, r5, r0
	ldr	r0, [r4, #4]
	bl	close(PLT)
	str	r6, [r4, #4]
	str	r6, [r4, #8]
.LBB136_15:
	mvn	r0, #1
.LBB136_16:
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#17:
.LCPI136_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_0+8)
.LCPI136_1:
	.long	_MergedGlobals(GOTOFF)
.LCPI136_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_1+8)
.LCPI136_3:
	.long	.L.str.1.148(GOTOFF)
.LCPI136_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_2+8)
.LCPI136_5:
	.long	.L.str.18.149(GOTOFF)
.LCPI136_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_3+8)
.LCPI136_7:
	.long	.L.str.2.150(GOTOFF)
.LCPI136_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_4+8)
.LCPI136_9:
	.long	.L.str.4.152(GOTOFF)
.LCPI136_10:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_5+8)
.LCPI136_11:
	.long	.L.str.5.153(GOTOFF)
.LCPI136_12:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_6+8)
.LCPI136_13:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_7+8)
.LCPI136_14:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_8+8)
.LCPI136_15:
	.long	.L.str.3.151(GOTOFF)
.LCPI136_16:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_9+8)
.LCPI136_17:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC136_10+8)
.Lfunc_end136:
	.size	halide_zynq_init, .Lfunc_end136-halide_zynq_init
	.cantunwind
	.fnend

	.section	.text.halide_zynq_free,"ax",%progbits
	.weak	halide_zynq_free
	.align	2
	.type	halide_zynq_free,%function
halide_zynq_free:                       @ @halide_zynq_free
	.fnstart
@ BB#0:
	bx	lr
.Lfunc_end137:
	.size	halide_zynq_free, .Lfunc_end137-halide_zynq_free
	.cantunwind
	.fnend

	.section	.text.halide_zynq_cma_alloc,"ax",%progbits
	.weak	halide_zynq_cma_alloc
	.align	2
	.type	halide_zynq_cma_alloc,%function
halide_zynq_cma_alloc:                  @ @halide_zynq_cma_alloc
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r11, lr}
	push	{r4, r5, r6, r7, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	.pad	#8
	sub	sp, sp, #8
	mov	r4, r0
	ldr	r0, .LCPI138_0
	ldr	r7, .LCPI138_1
.LPC138_0:
	add	r0, pc, r0
	add	r0, r7, r0
	ldr	r0, [r0, #4]
	cmp	r0, #0
	beq	.LBB138_9
@ BB#1:
	mov	r0, #36
	bl	malloc(PLT)
	mov	r6, r0
	cmp	r6, #0
	beq	.LBB138_11
@ BB#2:                                 @ %.preheader26.preheader
	add	r2, r4, #24
	mov	r1, #5
	mvn	r3, #3
.LBB138_3:                              @ %.preheader26
                                        @ =>This Inner Loop Header: Depth=1
	cmp	r3, #0
	beq	.LBB138_6
@ BB#4:                                 @   in Loop: Header=BB138_3 Depth=1
	ldr	r0, [r2], #-4
	add	r3, r3, #1
	sub	r1, r1, #1
	cmp	r0, #0
	beq	.LBB138_3
@ BB#5:
	cmp	r1, #1
	bhi	.LBB138_18
.LBB138_6:                              @ %.thread
	mov	r0, r6
	bl	free(PLT)
	mov	r0, #0
	mov	r1, #1024
	mov	r5, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB138_15
@ BB#7:
	ldr	r0, .LCPI138_12
	mov	r1, r4
	ldr	r2, .LCPI138_13
	strb	r5, [r1, #1023]!
.LPC138_7:
	add	r0, pc, r0
.LBB138_8:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	add	r2, r2, r0
	mov	r0, r4
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB138_17
.LBB138_9:
	mov	r0, #0
	mov	r1, #1024
	mov	r5, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB138_14
@ BB#10:
	mov	r1, r4
	ldr	r0, .LCPI138_18
	ldr	r2, .LCPI138_19
	strb	r5, [r1, #1023]!
.LPC138_11:
	add	r0, pc, r0
	b	.LBB138_13
.LBB138_11:
	mov	r0, #0
	mov	r1, #1024
	mov	r5, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB138_24
@ BB#12:
	ldr	r0, .LCPI138_15
	mov	r1, r4
	ldr	r2, .LCPI138_16
	strb	r5, [r1, #1023]!
.LPC138_9:
	add	r0, pc, r0
.LBB138_13:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit1
	add	r2, r2, r0
	mov	r0, r4
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB138_26
.LBB138_14:
	ldr	r0, .LCPI138_20
	ldr	r1, .LCPI138_19
.LPC138_12:
	add	r5, pc, r0
	b	.LBB138_25
.LBB138_15:
	ldr	r0, .LCPI138_14
	ldr	r1, .LCPI138_13
.LPC138_8:
	add	r5, pc, r0
.LBB138_16:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	add	r2, r1, r5
	mov	r0, #0
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI138_7
	add	r1, r0, r5
	mov	r0, #0
.LBB138_17:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	mvn	r5, #2
	b	.LBB138_27
.LBB138_18:
	ldr	r5, [r4, #60]
	mov	r2, #0
	cmp	r1, #3
	str	r5, [r6, #16]
	blo	.LBB138_33
@ BB#19:                                @ %.preheader
	subs	r12, r1, #2
	beq	.LBB138_33
@ BB#20:                                @ %.lr.ph.preheader
	mov	r3, #0
	cmp	r1, #2
	beq	.LBB138_30
@ BB#21:                                @ %overflow.checked
	mov	r2, #1
	sub	lr, r1, #2
	vdup.32	q8, r2
	mov	r3, lr
	vmov.32	d16[0], r5
	bfc	r3, #0, #2
	cmp	r3, #0
	beq	.LBB138_28
@ BB#22:                                @ %vector.body.preheader
	mov	r2, lr
	add	r5, r4, #12
	bfc	r2, #0, #2
.LBB138_23:                             @ %vector.body
                                        @ =>This Inner Loop Header: Depth=1
	vld1.32	{d18, d19}, [r5]!
	subs	r2, r2, #4
	vmul.i32	q8, q9, q8
	bne	.LBB138_23
	b	.LBB138_29
.LBB138_24:
	ldr	r0, .LCPI138_17
	ldr	r1, .LCPI138_16
.LPC138_10:
	add	r5, pc, r0
.LBB138_25:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit1
	add	r2, r1, r5
	mov	r0, #0
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI138_7
	add	r1, r0, r5
	mov	r0, #0
.LBB138_26:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit1
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	mvn	r5, #0
.LBB138_27:
	mov	r0, r5
	sub	sp, r11, #16
	pop	{r4, r5, r6, r7, r11, pc}
.LBB138_28:
	mov	r3, #0
.LBB138_29:                             @ %middle.block
	vext.32	q9, q8, q8, #2
	cmp	lr, r3
	vmul.i32	q0, q8, q9
	vmul.i32	q8, q0, d0[1]
	vmov.32	r5, d16[0]
	beq	.LBB138_32
.LBB138_30:                             @ %.lr.ph.preheader22
	add	r2, r4, r3, lsl #2
	sub	r1, r1, #2
	sub	r1, r1, r3
	add	r2, r2, #12
.LBB138_31:                             @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r3, [r2], #4
	subs	r1, r1, #1
	mul	r5, r3, r5
	bne	.LBB138_31
.LBB138_32:                             @ %.loopexit.loopexit
	mov	r2, r12
	str	r5, [r6, #16]
.LBB138_33:                             @ %.loopexit
	add	r1, r4, r2, lsl #2
	ldr	r2, .LCPI138_2
	ldr	r1, [r1, #12]
	str	r1, [r6, #4]
	str	r1, [r6, #8]
	mov	r1, #1000
	str	r0, [r6, #12]
.LPC138_1:
	add	r0, pc, r2
	add	r0, r7, r0
	mov	r2, r6
	ldr	r0, [r0, #4]
	bl	ioctl(PLT)
	mov	r5, r0
	cmp	r5, #0
	beq	.LBB138_36
@ BB#34:
	mov	r0, r6
	bl	free(PLT)
	mov	r0, #0
	mov	r1, #1024
	mov	r7, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB138_39
@ BB#35:                                @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EEC2EPvPc.exit6
	mov	r6, r4
	ldr	r0, .LCPI138_3
	strb	r7, [r6, #1023]!
.LPC138_2:
	add	r7, pc, r0
	mov	r0, r4
	ldr	r1, .LCPI138_4
	add	r2, r1, r7
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r5, #31
	str	r1, [sp]
	mov	r1, r6
	mov	r2, r5
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI138_5
	add	r2, r1, r7
	mov	r1, r6
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB138_40
.LBB138_36:
	mov	r5, #0
	str	r6, [r4]
	str	r5, [r4, #4]
	ldr	r1, [r6, #12]
	ldr	r3, [r6, #8]
	ldr	r12, .LCPI138_8
	ldr	r2, [r6, #16]
	mul	r1, r1, r3
.LPC138_4:
	add	r0, pc, r12
	add	r0, r7, r0
	ldr	lr, [r6, #32]
	ldr	r0, [r0, #4]
	mov	r3, #1
	mul	r1, r1, r2
	stm	sp, {r0, lr}
	mov	r0, #0
	mov	r2, #2
	bl	mmap(PLT)
	str	r0, [r4, #8]
	cmn	r0, #1
	bne	.LBB138_27
@ BB#37:
	mov	r0, r6
	bl	free(PLT)
	mov	r0, #0
	mov	r1, #1024
	mov	r5, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB138_41
@ BB#38:
	mov	r1, r4
	ldr	r0, .LCPI138_9
	ldr	r2, .LCPI138_10
	strb	r5, [r1, #1023]!
.LPC138_5:
	add	r0, pc, r0
	b	.LBB138_8
.LBB138_39:                             @ %.critedge
	ldr	r0, .LCPI138_6
	ldr	r1, .LCPI138_4
.LPC138_3:
	add	r6, pc, r0
	mov	r0, #0
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	mov	r1, #1
	asr	r3, r5, #31
	str	r1, [sp]
	mov	r1, #0
	mov	r2, r5
	bl	halide_int64_to_string(PLT)
	ldr	r1, .LCPI138_5
	add	r2, r1, r6
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI138_7
	add	r1, r0, r6
	mov	r0, #0
.LBB138_40:                             @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit7
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	mvn	r5, #1
	b	.LBB138_27
.LBB138_41:
	ldr	r0, .LCPI138_11
	ldr	r1, .LCPI138_10
.LPC138_6:
	add	r5, pc, r0
	b	.LBB138_16
	.align	2
@ BB#42:
.LCPI138_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_0+8)
.LCPI138_1:
	.long	_MergedGlobals(GOTOFF)
.LCPI138_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_1+8)
.LCPI138_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_2+8)
.LCPI138_4:
	.long	.L.str.11.157(GOTOFF)
.LCPI138_5:
	.long	.L.str.12.158(GOTOFF)
.LCPI138_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_3+8)
.LCPI138_7:
	.long	.L.str.18.149(GOTOFF)
.LCPI138_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_4+8)
.LCPI138_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_5+8)
.LCPI138_10:
	.long	.L.str.13.159(GOTOFF)
.LCPI138_11:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_6+8)
.LCPI138_12:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_7+8)
.LCPI138_13:
	.long	.L.str.10.156(GOTOFF)
.LCPI138_14:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_8+8)
.LCPI138_15:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_9+8)
.LCPI138_16:
	.long	.L.str.9.155(GOTOFF)
.LCPI138_17:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_10+8)
.LCPI138_18:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_11+8)
.LCPI138_19:
	.long	.L.str.8.154(GOTOFF)
.LCPI138_20:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC138_12+8)
.Lfunc_end138:
	.size	halide_zynq_cma_alloc, .Lfunc_end138-halide_zynq_cma_alloc
	.cantunwind
	.fnend

	.section	.text.halide_zynq_cma_free,"ax",%progbits
	.weak	halide_zynq_cma_free
	.align	2
	.type	halide_zynq_cma_free,%function
halide_zynq_cma_free:                   @ @halide_zynq_cma_free
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	mov	r4, r0
	ldr	r0, .LCPI139_0
	ldr	r6, .LCPI139_1
.LPC139_0:
	add	r0, pc, r0
	add	r0, r6, r0
	ldr	r0, [r0, #4]
	cmp	r0, #0
	beq	.LBB139_2
@ BB#1:
	ldr	r5, [r4]
	ldr	r0, [r4, #8]
	add	r3, r5, #8
	ldm	r3, {r1, r2, r3}
	mul	r1, r2, r1
	mul	r1, r1, r3
	bl	munmap(PLT)
	ldr	r0, .LCPI139_2
	movw	r1, #1002
	mov	r2, r5
.LPC139_1:
	add	r0, pc, r0
	add	r0, r6, r0
	ldr	r0, [r0, #4]
	bl	ioctl(PLT)
	mov	r0, r5
	bl	free(PLT)
	mov	r0, #0
	str	r0, [r4]
	str	r0, [r4, #4]
	pop	{r4, r5, r6, r10, r11, pc}
.LBB139_2:
	mov	r0, #0
	mov	r1, #1024
	mov	r5, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB139_4
@ BB#3:
	ldr	r0, .LCPI139_3
	mov	r1, r4
	ldr	r2, .LCPI139_4
	strb	r5, [r1, #1023]!
.LPC139_2:
	add	r0, pc, r0
	add	r2, r2, r0
	mov	r0, r4
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB139_5
.LBB139_4:
	ldr	r0, .LCPI139_5
	ldr	r1, .LCPI139_4
.LPC139_3:
	add	r5, pc, r0
	mov	r0, #0
	add	r2, r1, r5
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI139_6
	add	r1, r0, r5
	mov	r0, #0
.LBB139_5:                              @ %_ZN6Halide7Runtime8Internal12_GLOBAL__N_17PrinterILi1ELy1024EED2Ev.exit
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	mvn	r0, #0
	pop	{r4, r5, r6, r10, r11, pc}
	.align	2
@ BB#6:
.LCPI139_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC139_0+8)
.LCPI139_1:
	.long	_MergedGlobals(GOTOFF)
.LCPI139_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC139_1+8)
.LCPI139_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC139_2+8)
.LCPI139_4:
	.long	.L.str.8.154(GOTOFF)
.LCPI139_5:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC139_3+8)
.LCPI139_6:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end139:
	.size	halide_zynq_cma_free, .Lfunc_end139-halide_zynq_cma_free
	.cantunwind
	.fnend

	.section	.text.halide_zynq_subimage,"ax",%progbits
	.weak	halide_zynq_subimage
	.align	2
	.type	halide_zynq_subimage,%function
halide_zynq_subimage:                   @ @halide_zynq_subimage
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	ldr	r12, [r0]
	mov	r4, r1
	ldr	r5, [sp, #16]
	mov	lr, r12
	vld1.32	{d16, d17}, [lr]!
	ldr	r12, [r12, #32]
	vld1.32	{d18, d19}, [lr]
	str	r12, [r1, #32]
	vst1.32	{d16, d17}, [r4]!
	vst1.32	{d18, d19}, [r4]
	str	r3, [r1, #4]
	str	r5, [r1, #12]
	ldr	r0, [r0, #8]
	ldr	r3, [r1, #20]
	sub	r0, r2, r0
	add	r2, r3, r0
	str	r2, [r1, #20]
	ldr	r2, [r1, #32]
	add	r0, r2, r0
	str	r0, [r1, #32]
	mov	r0, #0
	pop	{r4, r5, r11, pc}
.Lfunc_end140:
	.size	halide_zynq_subimage, .Lfunc_end140-halide_zynq_subimage
	.cantunwind
	.fnend

	.section	.text.halide_zynq_hwacc_launch,"ax",%progbits
	.weak	halide_zynq_hwacc_launch
	.align	2
	.type	halide_zynq_hwacc_launch,%function
halide_zynq_hwacc_launch:               @ @halide_zynq_hwacc_launch
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r2, r0
	ldr	r0, .LCPI141_0
	ldr	r1, .LCPI141_1
.LPC141_0:
	add	r0, pc, r0
	add	r0, r1, r0
	ldr	r0, [r0, #8]
	cmp	r0, #0
	beq	.LBB141_2
@ BB#1:
	movw	r1, #1003
	bl	ioctl(PLT)
	pop	{r4, r5, r11, pc}
.LBB141_2:
	mov	r0, #0
	mov	r1, #1024
	mov	r5, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB141_4
@ BB#3:
	ldr	r0, .LCPI141_2
	mov	r1, r4
	ldr	r2, .LCPI141_3
	strb	r5, [r1, #1023]!
.LPC141_1:
	add	r0, pc, r0
	add	r2, r2, r0
	mov	r0, r4
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB141_5
.LBB141_4:
	ldr	r0, .LCPI141_4
	ldr	r1, .LCPI141_3
.LPC141_2:
	add	r5, pc, r0
	mov	r0, #0
	add	r2, r1, r5
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI141_5
	add	r1, r0, r5
	mov	r0, #0
.LBB141_5:
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	mvn	r0, #0
	pop	{r4, r5, r11, pc}
	.align	2
@ BB#6:
.LCPI141_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC141_0+8)
.LCPI141_1:
	.long	_MergedGlobals(GOTOFF)
.LCPI141_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC141_1+8)
.LCPI141_3:
	.long	.L.str.8.154(GOTOFF)
.LCPI141_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC141_2+8)
.LCPI141_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end141:
	.size	halide_zynq_hwacc_launch, .Lfunc_end141-halide_zynq_hwacc_launch
	.cantunwind
	.fnend

	.section	.text.halide_zynq_hwacc_sync,"ax",%progbits
	.weak	halide_zynq_hwacc_sync
	.align	2
	.type	halide_zynq_hwacc_sync,%function
halide_zynq_hwacc_sync:                 @ @halide_zynq_hwacc_sync
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r2, r0
	ldr	r0, .LCPI142_0
	ldr	r1, .LCPI142_1
.LPC142_0:
	add	r0, pc, r0
	add	r0, r1, r0
	ldr	r0, [r0, #8]
	cmp	r0, #0
	beq	.LBB142_2
@ BB#1:
	mov	r1, #1004
	bl	ioctl(PLT)
	pop	{r4, r5, r11, pc}
.LBB142_2:
	mov	r0, #0
	mov	r1, #1024
	mov	r5, #0
	bl	halide_malloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	beq	.LBB142_4
@ BB#3:
	ldr	r0, .LCPI142_2
	mov	r1, r4
	ldr	r2, .LCPI142_3
	strb	r5, [r1, #1023]!
.LPC142_1:
	add	r0, pc, r0
	add	r2, r2, r0
	mov	r0, r4
	bl	halide_string_to_string(PLT)
	mov	r0, #0
	mov	r1, r4
	b	.LBB142_5
.LBB142_4:
	ldr	r0, .LCPI142_4
	ldr	r1, .LCPI142_3
.LPC142_2:
	add	r5, pc, r0
	mov	r0, #0
	add	r2, r1, r5
	mov	r1, #0
	bl	halide_string_to_string(PLT)
	ldr	r0, .LCPI142_5
	add	r1, r0, r5
	mov	r0, #0
.LBB142_5:
	bl	halide_error(PLT)
	mov	r0, #0
	mov	r1, r4
	bl	halide_free(PLT)
	mvn	r0, #0
	pop	{r4, r5, r11, pc}
	.align	2
@ BB#6:
.LCPI142_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC142_0+8)
.LCPI142_1:
	.long	_MergedGlobals(GOTOFF)
.LCPI142_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC142_1+8)
.LCPI142_3:
	.long	.L.str.8.154(GOTOFF)
.LCPI142_4:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC142_2+8)
.LCPI142_5:
	.long	.L.str.18.149(GOTOFF)
.Lfunc_end142:
	.size	halide_zynq_hwacc_sync, .Lfunc_end142-halide_zynq_hwacc_sync
	.cantunwind
	.fnend

	.section	.text.__pipeline_zynq,"ax",%progbits
	.globl	__pipeline_zynq
	.align	4
	.type	__pipeline_zynq,%function
__pipeline_zynq:                        @ @__pipeline_zynq
	.fnstart
@ BB#0:                                 @ %entry
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.pad	#148
	sub	sp, sp, #148
	mov	r7, r0
	mov	r4, r1
	cmp	r7, #0
	beq	.LBB143_35
@ BB#1:                                 @ %assert succeeded
	ldmib	r7, {r0, r2}
	mov	r6, r7
	mov	r8, #0
	mov	r5, #0
	str	r2, [sp, #52]           @ 4-byte Spill
	ldr	r1, [r7, #12]
	str	r1, [sp, #28]           @ 4-byte Spill
	ldr	r3, [r7, #60]
	ldr	r1, [r7]
	str	r3, [sp, #12]           @ 4-byte Spill
	ldr	r3, [r6, #48]!
	orr	r0, r1, r0
	orrs	r0, r2, r0
	movweq	r8, #1
	str	r6, [sp, #56]           @ 4-byte Spill
	str	r3, [sp, #76]           @ 4-byte Spill
	cmp	r4, #0
	beq	.LBB143_37
@ BB#2:                                 @ %assert succeeded11
	ldr	r0, [r7, #44]
	mov	r6, #0
	str	r0, [sp, #72]           @ 4-byte Spill
	ldr	r0, [r7, #32]
	str	r0, [sp, #68]           @ 4-byte Spill
	ldr	r0, [r7, #28]
	str	r0, [sp, #20]           @ 4-byte Spill
	ldr	r0, [r7, #16]
	str	r7, [sp, #80]           @ 4-byte Spill
	str	r0, [sp, #24]           @ 4-byte Spill
	ldr	r0, [r4]
	str	r0, [sp, #92]           @ 4-byte Spill
	ldr	r0, [r4, #4]
	str	r0, [sp, #88]           @ 4-byte Spill
	movw	r0, #26215
	ldr	r10, [r4, #8]
	movt	r0, #26214
	str	r10, [sp, #48]          @ 4-byte Spill
	ldr	r2, [r4, #12]
	smmul	r0, r2, r0
	str	r2, [sp, #44]           @ 4-byte Spill
	asr	r1, r0, #8
	add	r0, r1, r0, lsr #31
	add	r1, r0, r0, lsl #2
	sub	r1, r2, r1, lsl #7
	ldr	r2, [r4, #16]
	add	r11, r0, r1, asr #31
	movw	r0, #34953
	movt	r0, #34952
	str	r2, [sp, #32]           @ 4-byte Spill
	smmla	r0, r2, r0, r2
	cmp	r11, #1
	movgt	r6, r11
	cmp	r11, #2
	mov	r9, r6
	asr	r1, r0, #8
	orrlt	r9, r9, #1
	add	r0, r1, r0, lsr #31
	sub	r1, r0, r0, lsl #4
	add	r1, r2, r1, lsl #5
	add	r0, r0, r1, asr #31
	mov	r1, r9
	str	r0, [sp, #84]           @ 4-byte Spill
	mul	r0, r11, r0
	sub	r7, r0, #1
	str	r0, [sp, #40]           @ 4-byte Spill
	mov	r0, r7
	bl	__aeabi_idiv(PLT)
	mls	r1, r9, r0, r7
	and	r2, r1, r6
	asr	r1, r1, #31
	sub	r0, r0, r2, asr #31
	bic	r1, r1, r6, asr #31
	add	lr, r0, r1
	rsb	r1, r9, #0
	bic	r0, r9, r6, asr #31
	and	r1, r1, r6, asr #31
	orr	r0, r0, r1
	ldr	r1, [sp, #88]           @ 4-byte Reload
	add	r9, r0, r0, lsl #2
	ldr	r0, [sp, #92]           @ 4-byte Reload
	orr	r0, r0, r1
	ldr	r1, [r4, #60]
	orrs	r0, r10, r0
	ldr	r0, [r4, #44]
	movweq	r5, #1
	cmp	r8, #1
	str	r0, [sp, #92]           @ 4-byte Spill
	ldr	r0, [r4, #52]
	ldr	r12, [r4, #48]
	str	r0, [sp, #36]           @ 4-byte Spill
	ldr	r0, [r4, #28]
	str	r0, [sp, #16]           @ 4-byte Spill
	ldr	r0, [r4, #32]
	str	r0, [sp, #88]           @ 4-byte Spill
	ldr	r0, [r4, #36]
	str	r0, [sp, #64]           @ 4-byte Spill
	ldr	r0, [r4, #20]
	str	r0, [sp, #60]           @ 4-byte Spill
	bne	.LBB143_4
@ BB#3:                                 @ %true_bb
	add	r0, r11, r11, lsl #2
	mov	r3, r12
	mvn	r12, #3
	ldr	r2, [sp, #84]           @ 4-byte Reload
	mov	r10, r5
	add	r7, r12, r0, lsl #7
	mov	r5, r1
	bic	r1, r12, r11, asr #31
	rsb	r12, r2, r2, lsl #4
	mov	r6, #4
	and	r7, r7, r11, asr #31
	orr	r0, r6, r0, lsl #7
	adr	r2, .LCPI143_35
	vld1.64	{d16, d17}, [r2:128]
	mov	r2, #8
	orr	r2, r2, r12, lsl #5
	mov	r12, r3
	ldr	r3, [sp, #80]           @ 4-byte Reload
	orr	r1, r7, r1
	cmp	r0, #4
	movgt	r6, r0
	add	r1, r1, #16
	str	r1, [r3, #44]
	add	r0, r6, #4
	mov	r1, #1
	str	r0, [r3, #12]
	str	r1, [r3, #28]
	mov	r1, r5
	str	r2, [r3, #16]
	mov	r5, r10
	str	r0, [r3, #32]
	mov	r0, #0
	str	r0, [r3, #20]
	str	r0, [r3, #36]
	ldr	r2, [sp, #56]           @ 4-byte Reload
	vst1.32	{d16, d17}, [r2]
	str	r0, [r3, #24]
	str	r0, [r3, #40]
.LBB143_4:                              @ %after_bb
	rsb	r7, lr, lr, lsl #4
	lsl	r6, r9, #7
	cmp	r5, #1
	bne	.LBB143_6
@ BB#5:                                 @ %after_bb44.thread
	mov	r0, #480
	mov	r3, #1
	add	r0, r0, r7, lsl #5
	vmov.i32	q8, #0x0
	str	r3, [r4, #60]
	add	r2, r4, #40
	str	r6, [r4, #12]
	mul	r1, r0, r6
	str	r3, [r4, #28]
	str	r0, [r4, #16]
	mov	r0, #3
	str	r6, [r4, #32]
	str	r0, [r4, #20]
	mov	r0, #0
	str	r1, [r4, #36]
	str	r0, [r4, #56]
	str	r0, [r4, #24]
	vst1.32	{d16, d17}, [r2]
	b	.LBB143_7
.LBB143_6:                              @ %after_bb44
	cmp	r8, #0
	beq	.LBB143_8
.LBB143_7:                              @ %destructor_block
	mov	r0, #0
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB143_8:                              @ %true_bb58
	ldr	r3, [sp, #12]           @ 4-byte Reload
	cmp	r3, #2
	bne	.LBB143_39
@ BB#9:                                 @ %assert succeeded62
	cmp	r1, #1
	bne	.LBB143_40
@ BB#10:                                @ %assert succeeded64
	add	r3, r11, r11, lsl #2
	mvn	r0, #3
	mov	r2, #4
	add	r1, r0, r3, lsl #7
	str	r3, [sp, #56]           @ 4-byte Spill
	orr	r3, r2, r3, lsl #7
	ldr	r10, [sp, #28]          @ 4-byte Reload
	bic	r0, r0, r11, asr #31
	and	r1, r1, r11, asr #31
	cmp	r3, #4
	orr	r0, r1, r0
	movgt	r2, r3
	add	r3, r0, r2
	ldr	r2, [sp, #72]           @ 4-byte Reload
	sub	r1, r2, #16
	cmp	r1, r0
	bgt	.LBB143_42
@ BB#11:                                @ %assert succeeded64
	rsb	r1, r10, #20
	add	r1, r1, r3
	cmp	r1, r2
	bgt	.LBB143_42
@ BB#12:                                @ %assert succeeded66
	ldr	r0, [sp, #84]           @ 4-byte Reload
	rsb	r0, r0, r0, lsl #4
	lsl	r1, r0, #5
	str	r1, [sp, #84]           @ 4-byte Spill
	ldr	r2, [sp, #76]           @ 4-byte Reload
	ldr	r9, [sp, #44]           @ 4-byte Reload
	ldr	r11, [sp, #68]          @ 4-byte Reload
	cmp	r2, #8
	ldr	r8, [sp, #32]           @ 4-byte Reload
	ldr	lr, [sp, #24]           @ 4-byte Reload
	bgt	.LBB143_43
@ BB#13:                                @ %assert succeeded66
	rsb	r1, lr, #16
	add	r0, r1, r0, lsl #5
	cmp	r0, r2
	bgt	.LBB143_43
@ BB#14:                                @ %assert succeeded68
	ldr	r3, [sp, #92]           @ 4-byte Reload
	cmp	r3, #0
	bgt	.LBB143_44
@ BB#15:                                @ %assert succeeded68
	sub	r0, r6, r9
	cmp	r0, r3
	bgt	.LBB143_44
@ BB#16:                                @ %assert succeeded70
	lsl	r0, r7, #5
	cmp	r12, #0
	bgt	.LBB143_45
@ BB#17:                                @ %assert succeeded70
	rsb	r1, r8, #480
	add	r1, r1, r0
	cmp	r1, r12
	bgt	.LBB143_45
@ BB#18:                                @ %assert succeeded72
	ldr	r6, [sp, #36]           @ 4-byte Reload
	ldr	r2, [sp, #20]           @ 4-byte Reload
	cmp	r6, #0
	bgt	.LBB143_46
@ BB#19:                                @ %assert succeeded72
	ldr	r0, [sp, #60]           @ 4-byte Reload
	rsb	r0, r0, #3
	cmp	r0, r6
	bgt	.LBB143_46
@ BB#20:                                @ %assert succeeded74
	cmp	r2, #1
	bne	.LBB143_49
@ BB#21:                                @ %assert succeeded76
	ldr	r2, [sp, #16]           @ 4-byte Reload
	cmp	r2, #1
	bne	.LBB143_50
@ BB#22:                                @ %assert succeeded78
	smull	r2, r3, r11, lr
	mov	r1, #0
	mov	r7, #0
	mov	r0, #0
	cmp	r2, #0
	movwge	r1, #1
	cmp	r3, #0
	movwlt	r7, #1
	moveq	r7, r1
	cmp	r7, #0
	beq	.LBB143_52
@ BB#23:                                @ %assert succeeded82
	smull	r2, r3, lr, r10
	mov	r1, #0
	cmp	r2, #0
	movwge	r1, #1
	cmp	r3, #0
	movwlt	r0, #1
	moveq	r0, r1
	cmp	r0, #0
	beq	.LBB143_53
@ BB#24:                                @ %assert succeeded86
	ldr	r0, [sp, #88]           @ 4-byte Reload
	mov	r1, #0
	mov	r7, #0
	mov	r10, r8
	smull	r2, r3, r0, r8
	mov	r0, #0
	cmp	r2, #0
	movwge	r1, #1
	cmp	r3, #0
	movwlt	r7, #1
	moveq	r7, r1
	cmp	r7, #0
	beq	.LBB143_54
@ BB#25:                                @ %assert succeeded88
	smull	r2, r3, r10, r9
	mov	r1, #0
	mov	r8, r6
	mov	r11, r12
	cmp	r2, #0
	movwge	r1, #1
	cmp	r3, #0
	movwlt	r0, #1
	moveq	r0, r1
	cmp	r0, #0
	beq	.LBB143_56
@ BB#26:                                @ %assert succeeded90
	ldr	r0, [sp, #64]           @ 4-byte Reload
	mov	r1, #0
	ldr	lr, [sp, #60]           @ 4-byte Reload
	mov	r7, #0
	smull	r6, r12, r0, lr
	mov	r0, #0
	cmp	r6, #0
	movwge	r1, #1
	cmp	r12, #0
	movwlt	r7, #1
	moveq	r7, r1
	cmp	r7, #0
	beq	.LBB143_58
@ BB#27:                                @ %assert succeeded92
	umull	r7, r1, lr, r2
	cmp	r7, #0
	mla	r1, lr, r3, r1
	asr	r3, lr, #31
	mla	r3, r3, r2, r1
	mov	r1, #0
	movwge	r1, #1
	cmp	r3, #0
	movwlt	r0, #1
	moveq	r0, r1
	cmp	r0, #0
	beq	.LBB143_60
@ BB#28:                                @ %assert succeeded94
	add	r0, r8, lr
	cmp	r8, #0
	blt	.LBB143_62
@ BB#29:                                @ %assert succeeded94
	cmp	r0, #4
	bge	.LBB143_62
@ BB#30:                                @ %assert succeeded96
	ldr	r3, [sp, #92]           @ 4-byte Reload
	add	r0, r11, r10
	ldr	r7, [sp, #84]           @ 4-byte Reload
	cmp	r11, #0
	blt	.LBB143_63
@ BB#31:                                @ %assert succeeded96
	cmp	r0, r7
	bgt	.LBB143_63
@ BB#32:                                @ %assert succeeded98
	ldr	r0, [sp, #56]           @ 4-byte Reload
	add	r2, r3, r9
	cmp	r3, #0
	lsl	r0, r0, #7
	blt	.LBB143_65
@ BB#33:                                @ %assert succeeded98
	cmp	r2, r0
	bgt	.LBB143_65
@ BB#34:                                @ %produce p2:processed
	ldr	r2, [sp, #72]           @ 4-byte Reload
	ldr	r1, .LCPI143_32
	ldr	r0, .LCPI143_31
	str	r2, [sp, #96]
.LPC143_18:
	add	r1, pc, r1
	ldr	r2, [sp, #76]           @ 4-byte Reload
	add	r1, r0, r1
	mov	r0, #0
	str	r2, [sp, #100]
	ldr	r2, [sp, #68]           @ 4-byte Reload
	str	r2, [sp, #104]
	str	r9, [sp, #108]
	str	r3, [sp, #112]
	str	r11, [sp, #116]
	str	r8, [sp, #120]
	ldr	r2, [sp, #88]           @ 4-byte Reload
	str	r2, [sp, #124]
	ldr	r2, [sp, #64]           @ 4-byte Reload
	str	r2, [sp, #128]
	ldr	r2, [sp, #52]           @ 4-byte Reload
	str	r2, [sp, #132]
	ldr	r2, [sp, #80]           @ 4-byte Reload
	str	r2, [sp, #136]
	ldr	r2, [sp, #48]           @ 4-byte Reload
	str	r2, [sp, #140]
	add	r2, sp, #96
	str	r4, [sp, #144]
	str	r2, [sp]
	mov	r2, #0
	ldr	r3, [sp, #40]           @ 4-byte Reload
	bl	halide_do_par_for(PLT)
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB143_35:                             @ %assert failed
	ldr	r0, .LCPI143_34
	ldr	r1, .LCPI143_17
.LPC143_20:
	add	r0, pc, r0
	b	.LBB143_38
	.align	4
@ BB#36:
.LCPI143_35:
	.long	8                       @ 0x8
	.long	0                       @ 0x0
	.long	0                       @ 0x0
	.long	2                       @ 0x2
.LBB143_37:                             @ %assert failed10
	ldr	r0, .LCPI143_33
	ldr	r1, .LCPI143_20
.LPC143_19:
	add	r0, pc, r0
.LBB143_38:                             @ %assert failed
	add	r1, r1, r0
	mov	r0, #0
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	b	halide_error_buffer_argument_is_null(PLT)
.LBB143_39:                             @ %assert failed61
	ldr	r2, .LCPI143_3
	mov	r7, #2
	ldr	r0, .LCPI143_1
	ldr	r1, .LCPI143_2
.LPC143_0:
	add	r2, pc, r2
	str	r7, [sp]
	b	.LBB143_41
.LBB143_40:                             @ %assert failed63
	ldr	r2, .LCPI143_6
	mov	r7, #1
	mov	r3, r1
	ldr	r0, .LCPI143_4
	ldr	r1, .LCPI143_5
.LPC143_1:
	add	r2, pc, r2
	str	r7, [sp]
.LBB143_41:                             @ %assert failed61
	add	r1, r1, r2
	add	r2, r0, r2
	mov	r0, #0
	bl	halide_error_bad_elem_size(PLT)
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB143_42:                             @ %assert failed65
	ldr	r6, .LCPI143_7
	add	r7, r10, r2
	add	r3, r3, #19
	ldr	r1, .LCPI143_2
	str	r3, [sp]
	sub	r7, r7, #1
	stmib	sp, {r2, r7}
.LPC143_2:
	add	r2, pc, r6
	add	r1, r1, r2
	add	r3, r0, #16
	mov	r0, #0
	mov	r2, #0
	b	.LBB143_48
.LBB143_43:                             @ %assert failed67
	ldr	r3, [sp, #84]           @ 4-byte Reload
	ldr	r1, .LCPI143_8
	ldr	r0, .LCPI143_2
	orr	r7, r3, #15
	add	r3, lr, r2
.LPC143_3:
	add	r1, pc, r1
	sub	r3, r3, #1
	str	r7, [sp]
	add	r1, r0, r1
	stmib	sp, {r2, r3}
	mov	r0, #0
	mov	r2, #1
	mov	r3, #8
	b	.LBB143_48
.LBB143_44:                             @ %assert failed69
	ldr	r1, .LCPI143_9
	mov	r7, r3
	ldr	r0, .LCPI143_5
	add	r3, r9, r7
.LPC143_4:
	add	r1, pc, r1
	sub	r2, r6, #1
	stm	sp, {r2, r7}
	sub	r3, r3, #1
	add	r1, r0, r1
	mov	r0, #0
	mov	r2, #0
	str	r3, [sp, #8]
	b	.LBB143_47
.LBB143_45:                             @ %assert failed71
	movw	r3, #479
	ldr	r2, .LCPI143_10
	add	r0, r0, r3
	add	r3, r8, r12
	ldr	r1, .LCPI143_5
	sub	r3, r3, #1
	stm	sp, {r0, r12}
.LPC143_5:
	add	r0, pc, r2
	add	r1, r1, r0
	mov	r0, #0
	str	r3, [sp, #8]
	mov	r2, #1
	b	.LBB143_47
.LBB143_46:                             @ %assert failed73
	ldr	r3, [sp, #60]           @ 4-byte Reload
	mov	r2, #2
	ldr	r1, .LCPI143_11
	add	r3, r3, r6
	ldr	r0, .LCPI143_5
.LPC143_6:
	add	r1, pc, r1
	sub	r3, r3, #1
	stm	sp, {r2, r6}
	add	r1, r0, r1
	mov	r0, #0
	mov	r2, #2
	str	r3, [sp, #8]
.LBB143_47:                             @ %assert failed69
	mov	r3, #0
.LBB143_48:                             @ %assert failed69
	bl	halide_error_access_out_of_bounds(PLT)
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB143_49:                             @ %assert failed75
	ldr	r0, .LCPI143_12
	mov	r3, #1
	ldr	r1, .LCPI143_13
	ldr	r7, .LCPI143_14
	str	r3, [sp]
.LPC143_7:
	add	r3, pc, r7
	b	.LBB143_51
.LBB143_50:                             @ %assert failed77
	ldr	r7, .LCPI143_16
	mov	r3, #1
	str	r3, [sp]
	ldr	r0, .LCPI143_12
.LPC143_8:
	add	r3, pc, r7
	ldr	r1, .LCPI143_15
.LBB143_51:                             @ %assert failed75
	add	r1, r1, r3
	add	r3, r0, r3
	mov	r0, #0
	bl	halide_error_constraint_violated(PLT)
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB143_52:                             @ %assert failed81
	ldr	r1, .LCPI143_17
	mvn	r6, #-2147483648
	ldr	r7, .LCPI143_18
	str	r6, [sp]
	str	r0, [sp, #4]
.LPC143_9:
	add	r0, pc, r7
	b	.LBB143_55
.LBB143_53:                             @ %assert failed83
	ldr	r1, .LCPI143_19
	mvn	r6, #-2147483648
	ldr	r0, .LCPI143_17
	mov	r7, #0
.LPC143_10:
	add	r1, pc, r1
	stm	sp, {r6, r7}
	b	.LBB143_57
.LBB143_54:                             @ %assert failed87
	ldr	r7, .LCPI143_21
	mvn	r6, #-2147483648
	str	r6, [sp]
	str	r0, [sp, #4]
.LPC143_11:
	add	r0, pc, r7
	ldr	r1, .LCPI143_20
.LBB143_55:                             @ %assert failed81
	add	r1, r1, r0
	mov	r0, #0
	b	.LBB143_59
.LBB143_56:                             @ %assert failed89
	ldr	r1, .LCPI143_22
	mvn	r6, #-2147483648
	mov	r7, #0
	ldr	r0, .LCPI143_20
	stm	sp, {r6, r7}
.LPC143_12:
	add	r1, pc, r1
.LBB143_57:                             @ %assert failed83
	add	r1, r0, r1
	mov	r0, #0
	b	.LBB143_61
.LBB143_58:                             @ %assert failed91
	ldr	r2, .LCPI143_23
	mvn	r3, #-2147483648
	ldr	r1, .LCPI143_20
	str	r3, [sp]
	mov	r3, r12
	str	r0, [sp, #4]
.LPC143_13:
	add	r0, pc, r2
	add	r1, r1, r0
	mov	r0, #0
	mov	r2, r6
.LBB143_59:                             @ %assert failed81
	bl	halide_error_buffer_allocation_too_large(PLT)
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB143_60:                             @ %assert failed93
	ldr	r1, .LCPI143_24
	mvn	r6, #-2147483648
	ldr	r0, .LCPI143_20
	mov	r2, #0
.LPC143_14:
	add	r1, pc, r1
	str	r6, [sp]
	str	r2, [sp, #4]
	add	r1, r0, r1
	mov	r0, #0
	mov	r2, r7
.LBB143_61:                             @ %assert failed83
	bl	halide_error_buffer_extents_too_large(PLT)
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB143_62:                             @ %assert failed95
	ldr	r2, .LCPI143_20
	mov	r7, #2
	ldr	r1, .LCPI143_25
	sub	r0, r0, #1
	ldr	r3, .LCPI143_26
	stm	sp, {r7, r8}
	str	r0, [sp, #8]
.LPC143_15:
	add	r0, pc, r3
	b	.LBB143_64
.LBB143_63:                             @ %assert failed97
	ldr	r3, .LCPI143_28
	sub	r7, r7, #1
	sub	r0, r0, #1
	stm	sp, {r7, r11}
	str	r0, [sp, #8]
.LPC143_16:
	add	r0, pc, r3
	ldr	r2, .LCPI143_20
	ldr	r1, .LCPI143_27
.LBB143_64:                             @ %assert failed95
	add	r1, r1, r0
	add	r2, r2, r0
	b	.LBB143_66
.LBB143_65:                             @ %assert failed99
	ldr	r7, .LCPI143_30
	sub	r0, r0, #1
	ldr	r6, .LCPI143_20
	sub	r2, r2, #1
	ldr	r1, .LCPI143_29
	stm	sp, {r0, r3}
.LPC143_17:
	add	r0, pc, r7
	add	r1, r1, r0
	str	r2, [sp, #8]
	add	r2, r6, r0
.LBB143_66:                             @ %assert failed95
	mov	r0, #0
	mov	r3, #0
	bl	halide_error_explicit_bounds_too_small(PLT)
	add	sp, sp, #148
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	2
@ BB#67:
.LCPI143_1:
	.long	.Lstr.162(GOTOFF)
.LCPI143_2:
	.long	.Lstr.161(GOTOFF)
.LCPI143_3:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_0+8)
.LCPI143_4:
	.long	.Lstr.164(GOTOFF)
.LCPI143_5:
	.long	.Lstr.163(GOTOFF)
.LCPI143_6:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_1+8)
.LCPI143_7:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_2+8)
.LCPI143_8:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_3+8)
.LCPI143_9:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_4+8)
.LCPI143_10:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_5+8)
.LCPI143_11:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_6+8)
.LCPI143_12:
	.long	.Lstr.166(GOTOFF)
.LCPI143_13:
	.long	.Lstr.165(GOTOFF)
.LCPI143_14:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_7+8)
.LCPI143_15:
	.long	.Lstr.167(GOTOFF)
.LCPI143_16:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_8+8)
.LCPI143_17:
	.long	.Lstr(GOTOFF)
.LCPI143_18:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_9+8)
.LCPI143_19:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_10+8)
.LCPI143_20:
	.long	.Lstr.160(GOTOFF)
.LCPI143_21:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_11+8)
.LCPI143_22:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_12+8)
.LCPI143_23:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_13+8)
.LCPI143_24:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_14+8)
.LCPI143_25:
	.long	.Lstr.168(GOTOFF)
.LCPI143_26:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_15+8)
.LCPI143_27:
	.long	.Lstr.169(GOTOFF)
.LCPI143_28:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_16+8)
.LCPI143_29:
	.long	.Lstr.170(GOTOFF)
.LCPI143_30:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_17+8)
.LCPI143_31:
	.long	"par_for___pipeline_zynq_p2:processed.s0.x.xo.xo"(GOTOFF)
.LCPI143_32:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_18+8)
.LCPI143_33:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_19+8)
.LCPI143_34:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC143_20+8)
.Lfunc_end143:
	.size	__pipeline_zynq, .Lfunc_end143-__pipeline_zynq
	.cantunwind
	.fnend

	.section	".text.par_for___pipeline_zynq_p2:processed.s0.x.xo.xo","ax",%progbits
	.align	4
	.type	"par_for___pipeline_zynq_p2:processed.s0.x.xo.xo",%function
"par_for___pipeline_zynq_p2:processed.s0.x.xo.xo": @ @"par_for___pipeline_zynq_p2:processed.s0.x.xo.xo"
	.fnstart
@ BB#0:                                 @ %entry
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.setfp	r11, sp, #28
	add	r11, sp, #28
	.pad	#196
	sub	sp, sp, #196
	mov	r9, r1
	ldr	r1, [r2, #16]
	str	r0, [r11, #-188]        @ 4-byte Spill
	mov	r4, #0
	ldr	r0, [r2, #44]
	str	r1, [r11, #-196]        @ 4-byte Spill
	ldr	r1, [r2, #20]
	str	r0, [r11, #-192]        @ 4-byte Spill
	ldr	r0, [r2, #36]
	str	r1, [r11, #-204]        @ 4-byte Spill
	ldr	r1, [r2, #24]
	str	r0, [r11, #-212]        @ 4-byte Spill
	ldr	r0, [r2, #4]
	str	r1, [r11, #-200]        @ 4-byte Spill
	ldr	r1, [r2]
	str	r0, [r11, #-220]        @ 4-byte Spill
	ldr	r0, [r2, #8]
	str	r1, [r11, #-224]        @ 4-byte Spill
	mov	r1, #0
	str	r1, [r11, #-168]
	mov	r1, #2
	str	r0, [r11, #-216]        @ 4-byte Spill
	ldr	r0, [r2, #12]
	str	r1, [r11, #-116]
	movw	r1, #26215
	movt	r1, #26214
	ldr	r5, [r2, #32]
	smmul	r1, r0, r1
	ldr	r8, [r2, #28]
	asr	r2, r1, #8
	add	r1, r2, r1, lsr #31
	add	r2, r1, r1, lsl #2
	sub	r0, r0, r2, lsl #7
	add	r0, r1, r0, asr #31
	cmp	r0, #1
	movgt	r4, r0
	cmp	r0, #2
	mov	r7, r4
	orrlt	r7, r7, #1
	rsb	r0, r7, #0
	bic	r1, r7, r4, asr #31
	and	r0, r0, r4, asr #31
	orr	r6, r1, r0
	mov	r0, r9
	mov	r1, r7
	bl	__modsi3(PLT)
	add	r1, r6, r0
	and	r1, r1, r0, asr #31
	bic	r0, r0, r0, asr #31
	orr	r0, r1, r0
	mvn	r1, #3
	add	r0, r0, r0, lsl #2
	str	r0, [r11, #-184]        @ 4-byte Spill
	add	r0, r1, r0, lsl #7
	mov	r1, r7
	str	r0, [r11, #-132]
	mov	r0, r9
	bl	__aeabi_idiv(PLT)
	mov	r10, r0
	mov	r2, #0
	mls	r0, r7, r10, r9
	asr	r1, r0, #31
	bic	r9, r1, r4, asr #31
	and	r4, r0, r4
	sub	r0, r10, r4, asr #31
	add	r0, r0, r9
	rsb	r6, r0, r0, lsl #4
	mvn	r0, #3
	add	r7, r0, r6, lsl #5
	adr	r0, .LCPI144_0
	vld1.64	{d16, d17}, [r0:128]
	sub	r0, r11, #176
	add	r1, r0, #12
	str	r7, [r11, #-128]
	str	r2, [r11, #-124]
	str	r2, [r11, #-120]
	vst1.32	{d16, d17}, [r1]
	adr	r1, .LCPI144_1
	vld1.64	{d16, d17}, [r1:128]
	add	r1, r0, #28
	vst1.32	{d16, d17}, [r1]
	strb	r2, [r11, #-112]
	strb	r2, [r11, #-111]
	str	r2, [r11, #-172]
	str	r2, [r11, #-176]
	bl	halide_zynq_cma_alloc(PLT)
	cmp	r0, #0
	bne	.LBB144_16
@ BB#1:                                 @ %assert succeeded
	ldr	r2, [r11, #-168]
	cmp	r2, #0
	beq	.LBB144_13
@ BB#2:                                 @ %for p2:shifted.s0.y.preheader
	asr	r0, r4, #31
	add	r1, r9, r10
	ldr	r4, [r11, #-216]        @ 4-byte Reload
	lsl	lr, r6, #5
	sub	r0, r1, r0
	ldr	r3, [r11, #-184]        @ 4-byte Reload
	str	r0, [r11, #-208]        @ 4-byte Spill
	rsb	r0, r0, r0, lsl #4
	mov	r1, #8
	str	r2, [r11, #-180]        @ 4-byte Spill
	lsl	r12, r3, #7
	orr	r0, r1, r0, lsl #5
	ldr	r1, [r11, #-220]        @ 4-byte Reload
	sub	r0, r0, r1
	movw	r1, #483
	mul	r0, r4, r0
	add	r9, lr, r1
	ldr	r1, [r11, #-224]        @ 4-byte Reload
	lsl	r4, r4, #1
	add	r0, r0, r3, lsl #7
	add	r0, r0, #12
	sub	r0, r0, r1
	ldr	r1, [r11, #-212]        @ 4-byte Reload
	add	r3, r1, r0, lsl #1
.LBB144_3:                              @ %for p2:shifted.s0.y
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB144_4 Depth 2
	mov	r0, #81
	mov	r6, r3
	mov	r1, r2
.LBB144_4:                              @ %for p2:shifted.s0.x.x
                                        @   Parent Loop BB144_3 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	vld1.16	{d16, d17}, [r6]!
	subs	r0, r0, #1
	vst1.16	{d16, d17}, [r1:128]!
	bne	.LBB144_4
@ BB#5:                                 @ %end for p2:shifted.s0.x.x
                                        @   in Loop: Header=BB144_3 Depth=1
	add	r0, r7, #1
	cmp	r7, r9
	add	r3, r3, r4
	add	r2, r2, #1296
	mov	r7, r0
	bne	.LBB144_3
@ BB#6:                                 @ %consume p2:shifted
	adr	r0, .LCPI144_2
	mov	r1, #0
	vld1.64	{d16, d17}, [r0:128]
	adr	r0, .LCPI144_3
	vld1.64	{d18, d19}, [r0:128]
	mov	r0, #1
	str	r1, [r11, #-96]
	str	r0, [r11, #-44]
	sub	r0, r11, #60
	stm	r0, {r1, r12, lr}
	sub	r0, r11, #104
	add	r2, r0, #12
	str	r1, [r11, #-48]
	vst1.32	{d18, d19}, [r2]
	add	r2, r0, #28
	vst1.32	{d16, d17}, [r2]
	strb	r1, [r11, #-40]
	strb	r1, [r11, #-39]
	str	r1, [r11, #-100]
	str	r1, [r11, #-104]
	bl	halide_zynq_cma_alloc(PLT)
	mov	r4, r0
	cmp	r4, #0
	bne	.LBB144_15
@ BB#7:                                 @ %assert succeeded31
	ldr	r10, [r11, #-96]
	ldr	r2, [r11, #-180]        @ 4-byte Reload
	cmp	r10, #0
	beq	.LBB144_14
@ BB#8:                                 @ %assert succeeded34
	mov	r9, sp
	sub	r7, r9, #40
	mov	sp, r7
	sub	sp, sp, #8
	mov	r0, #488
	mov	r1, r7
	str	r0, [sp]
	sub	r0, r11, #176
	mov	r3, #648
	bl	halide_zynq_subimage(PLT)
	add	sp, sp, #8
	mov	r6, sp
	sub	r4, r6, #40
	mov	sp, r4
	sub	sp, sp, #8
	mov	r0, #480
	mov	r1, r4
	str	r0, [sp]
	sub	r0, r11, #104
	mov	r2, r10
	mov	r3, #640
	bl	halide_zynq_subimage(PLT)
	add	sp, sp, #8
	mov	r1, sp
	sub	r0, r1, #72
	mov	sp, r0
	ldr	r2, [r9, #-8]
	mov	r3, r0
	vld1.64	{d16, d17}, [r7]!
	vst1.64	{d16, d17}, [r3]!
	vld1.64	{d18, d19}, [r7]
	vst1.64	{d18, d19}, [r3]
	sub	r3, r1, #36
	str	r2, [r1, #-40]
	vld1.32	{d16, d17}, [r4]!
	ldr	r2, [r6, #-8]
	vld1.32	{d18, d19}, [r4]
	vst1.32	{d16, d17}, [r3]
	str	r2, [r1, #-4]
	sub	r1, r1, #20
	vst1.32	{d18, d19}, [r1]
	bl	halide_zynq_hwacc_launch(PLT)
	bl	halide_zynq_hwacc_sync(PLT)
	ldr	r0, [r11, #-208]        @ 4-byte Reload
	mov	lr, #0
	ldr	r1, [r11, #-196]        @ 4-byte Reload
	mov	r4, r10
	ldr	r2, [r11, #-204]        @ 4-byte Reload
	mul	r0, r8, r0
	mla	r1, r8, r2, r1
	ldr	r2, [r11, #-200]        @ 4-byte Reload
	rsb	r0, r0, r0, lsl #4
	mla	r1, r5, r2, r1
	ldr	r2, [r11, #-184]        @ 4-byte Reload
	lsl	r0, r0, #5
	add	r0, r0, r2, lsl #7
	sub	r0, r0, r1
	ldr	r1, [r11, #-192]        @ 4-byte Reload
	add	r12, r1, r0
	lsl	r1, r5, #1
.LBB144_9:                              @ %for p2:processed.s0.y.yi
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB144_10 Depth 2
	mov	r7, #40
	mov	r3, r4
	mov	r6, r12
.LBB144_10:                             @ %for p2:processed.s0.x.xi.xi
                                        @   Parent Loop BB144_9 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	vld3.8	{d16, d18, d20}, [r3:64]!
	mov	r0, r6
	add	r2, r1, r6
	add	r6, r5, r6
	subs	r7, r7, #1
	vld3.8	{d17, d19, d21}, [r3:64]!
	vst1.8	{d16, d17}, [r0]!
	vst1.8	{d18, d19}, [r6]
	mov	r6, r0
	vst1.8	{d20, d21}, [r2]
	bne	.LBB144_10
@ BB#11:                                @ %end for p2:processed.s0.x.xi.xi
                                        @   in Loop: Header=BB144_9 Depth=1
	add	lr, lr, #1
	add	r12, r12, r8
	add	r4, r4, #1920
	cmp	lr, #480
	bne	.LBB144_9
@ BB#12:                                @ %call_destructor.exit41
	sub	r0, r11, #104
	bl	halide_zynq_cma_free(PLT)
	ldr	r4, [r11, #-188]        @ 4-byte Reload
	mov	r1, r10
	mov	r0, r4
	bl	halide_zynq_free(PLT)
	sub	r0, r11, #176
	bl	halide_zynq_cma_free(PLT)
	ldr	r1, [r11, #-180]        @ 4-byte Reload
	mov	r0, r4
	bl	halide_zynq_free(PLT)
	mov	r0, #0
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB144_13:                             @ %assert failed11
	ldr	r0, [r11, #-188]        @ 4-byte Reload
	bl	halide_error_out_of_memory(PLT)
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.LBB144_14:                             @ %call_destructor.exit
	ldr	r0, [r11, #-188]        @ 4-byte Reload
	bl	halide_error_out_of_memory(PLT)
	mov	r4, r0
	mov	r0, #0
	cmp	r4, #0
	beq	.LBB144_16
.LBB144_15:                             @ %call_destructor.exit.thread
	ldr	r0, [r11, #-188]        @ 4-byte Reload
	ldr	r1, [r11, #-180]        @ 4-byte Reload
	bl	halide_zynq_free(PLT)
	mov	r0, r4
.LBB144_16:                             @ %call_destructor.exit39
	sub	sp, r11, #28
	pop	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.align	4
@ BB#17:
.LCPI144_0:
	.long	648                     @ 0x288
	.long	488                     @ 0x1e8
	.long	0                       @ 0x0
	.long	0                       @ 0x0
.LCPI144_1:
	.long	1                       @ 0x1
	.long	648                     @ 0x288
	.long	0                       @ 0x0
	.long	0                       @ 0x0
.LCPI144_2:
	.long	1                       @ 0x1
	.long	3                       @ 0x3
	.long	1920                    @ 0x780
	.long	0                       @ 0x0
.LCPI144_3:
	.long	3                       @ 0x3
	.long	640                     @ 0x280
	.long	480                     @ 0x1e0
	.long	0                       @ 0x0
.Lfunc_end144:
	.size	"par_for___pipeline_zynq_p2:processed.s0.x.xo.xo", .Lfunc_end144-"par_for___pipeline_zynq_p2:processed.s0.x.xo.xo"
	.cantunwind
	.fnend

	.section	.text.pipeline_zynq,"ax",%progbits
	.globl	pipeline_zynq
	.align	2
	.type	pipeline_zynq,%function
pipeline_zynq:                          @ @pipeline_zynq
	.fnstart
@ BB#0:                                 @ %entry
	cmp	r0, #0
	beq	.LBB145_3
@ BB#1:                                 @ %assert succeeded
	cmp	r1, #0
	beq	.LBB145_4
@ BB#2:                                 @ %assert succeeded11
	b	__pipeline_zynq(PLT)
.LBB145_3:                              @ %assert failed
	ldr	r0, .LCPI145_2
	ldr	r1, .LCPI145_3
.LPC145_1:
	add	r0, pc, r0
	b	.LBB145_5
.LBB145_4:                              @ %assert failed10
	ldr	r0, .LCPI145_0
	ldr	r1, .LCPI145_1
.LPC145_0:
	add	r0, pc, r0
.LBB145_5:                              @ %assert failed
	add	r1, r1, r0
	mov	r0, #0
	b	halide_error_buffer_argument_is_null(PLT)
	.align	2
@ BB#6:
.LCPI145_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC145_0+8)
.LCPI145_1:
	.long	.Lstr.160(GOTOFF)
.LCPI145_2:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC145_1+8)
.LCPI145_3:
	.long	.Lstr(GOTOFF)
.Lfunc_end145:
	.size	pipeline_zynq, .Lfunc_end145-pipeline_zynq
	.cantunwind
	.fnend

	.section	.text.pipeline_zynq_argv,"ax",%progbits
	.globl	pipeline_zynq_argv
	.align	2
	.type	pipeline_zynq_argv,%function
pipeline_zynq_argv:                     @ @pipeline_zynq_argv
	.fnstart
@ BB#0:                                 @ %entry
	ldr	r2, [r0]
	ldr	r1, [r0, #4]
	mov	r0, r2
	b	pipeline_zynq(PLT)
.Lfunc_end146:
	.size	pipeline_zynq_argv, .Lfunc_end146-pipeline_zynq_argv
	.cantunwind
	.fnend

	.section	.text.pipeline_zynq_metadata,"ax",%progbits
	.globl	pipeline_zynq_metadata
	.align	2
	.type	pipeline_zynq_metadata,%function
pipeline_zynq_metadata:                 @ @pipeline_zynq_metadata
	.fnstart
@ BB#0:                                 @ %entry
	ldr	r0, .LCPI147_0
	ldr	r1, .LCPI147_1
.LPC147_0:
	add	r0, pc, r0
	add	r0, r1, r0
	bx	lr
	.align	2
@ BB#1:
.LCPI147_0:
	.long	_GLOBAL_OFFSET_TABLE_-(.LPC147_0+8)
.LCPI147_1:
	.long	.Lpipeline_zynq_metadata_storage(GOTOFF)
.Lfunc_end147:
	.size	pipeline_zynq_metadata, .Lfunc_end147-pipeline_zynq_metadata
	.cantunwind
	.fnend

	.type	_ZN6Halide7Runtime8Internal13custom_mallocE,%object @ @_ZN6Halide7Runtime8Internal13custom_mallocE
	.section	.data.rel,"aw",%progbits
	.weak	_ZN6Halide7Runtime8Internal13custom_mallocE
	.align	2
_ZN6Halide7Runtime8Internal13custom_mallocE:
	.long	_ZN6Halide7Runtime8Internal14default_mallocEPvj
	.size	_ZN6Halide7Runtime8Internal13custom_mallocE, 4

	.type	_ZN6Halide7Runtime8Internal11custom_freeE,%object @ @_ZN6Halide7Runtime8Internal11custom_freeE
	.weak	_ZN6Halide7Runtime8Internal11custom_freeE
	.align	2
_ZN6Halide7Runtime8Internal11custom_freeE:
	.long	_ZN6Halide7Runtime8Internal12default_freeEPvS2_
	.size	_ZN6Halide7Runtime8Internal11custom_freeE, 4

	.type	_ZN6Halide7Runtime8Internal13error_handlerE,%object @ @_ZN6Halide7Runtime8Internal13error_handlerE
	.weak	_ZN6Halide7Runtime8Internal13error_handlerE
	.align	2
_ZN6Halide7Runtime8Internal13error_handlerE:
	.long	_ZN6Halide7Runtime8Internal21default_error_handlerEPvPKc
	.size	_ZN6Halide7Runtime8Internal13error_handlerE, 4

	.type	.L.str,%object          @ @.str
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str:
	.asciz	"Error: "
	.size	.L.str, 8

	.type	_ZN6Halide7Runtime8Internal12custom_printE,%object @ @_ZN6Halide7Runtime8Internal12custom_printE
	.section	.data.rel,"aw",%progbits
	.weak	_ZN6Halide7Runtime8Internal12custom_printE
	.align	2
_ZN6Halide7Runtime8Internal12custom_printE:
	.long	_ZN6Halide7Runtime8Internal17halide_print_implEPvPKc
	.size	_ZN6Halide7Runtime8Internal12custom_printE, 4

	.type	_ZN6Halide7Runtime8Internal29halide_reference_clock_initedE,%object @ @_ZN6Halide7Runtime8Internal29halide_reference_clock_initedE
	.bss
	.weak	_ZN6Halide7Runtime8Internal29halide_reference_clock_initedE
_ZN6Halide7Runtime8Internal29halide_reference_clock_initedE:
	.byte	0                       @ 0x0
	.size	_ZN6Halide7Runtime8Internal29halide_reference_clock_initedE, 1

	.type	_ZN6Halide7Runtime8Internal22halide_reference_clockE,%object @ @_ZN6Halide7Runtime8Internal22halide_reference_clockE
	.weak	_ZN6Halide7Runtime8Internal22halide_reference_clockE
	.align	2
_ZN6Halide7Runtime8Internal22halide_reference_clockE:
	.zero	8
	.size	_ZN6Halide7Runtime8Internal22halide_reference_clockE, 8

	.type	.L.str.7,%object        @ @.str.7
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.7:
	.asciz	"/tmp/"
	.size	.L.str.7, 6

	.type	.L.str.1,%object        @ @.str.1
.L.str.1:
	.asciz	"XXXXXX"
	.size	.L.str.1, 7

	.type	_ZN6Halide7Runtime8Internal10work_queueE,%object @ @_ZN6Halide7Runtime8Internal10work_queueE
	.bss
	.weak	_ZN6Halide7Runtime8Internal10work_queueE
	.align	3
_ZN6Halide7Runtime8Internal10work_queueE:
	.zero	544
	.size	_ZN6Halide7Runtime8Internal10work_queueE, 544

	.type	custom_do_task,%object  @ @custom_do_task
	.section	.data.rel,"aw",%progbits
	.weak	custom_do_task
	.align	2
custom_do_task:
	.long	_ZN6Halide7Runtime8Internal15default_do_taskEPvPFiS2_iPhEiS3_
	.size	custom_do_task, 4

	.type	custom_do_par_for,%object @ @custom_do_par_for
	.weak	custom_do_par_for
	.align	2
custom_do_par_for:
	.long	_ZN6Halide7Runtime8Internal18default_do_par_forEPvPFiS2_iPhEiiS3_
	.size	custom_do_par_for, 4

	.section	.fini_array,"aw",%fini_array
	.align	2
	.long	halide_thread_pool_cleanup(target1)
	.long	halide_profiler_shutdown(target1)
	.long	halide_trace_cleanup(target1)
	.long	halide_cache_cleanup(target1)
	.type	.L.str.8,%object        @ @.str.8
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.8:
	.asciz	"HL_NUM_THREADS"
	.size	.L.str.8, 15

	.type	.L.str.1.9,%object      @ @.str.1.9
.L.str.1.9:
	.asciz	"HL_NUMTHREADS"
	.size	.L.str.1.9, 14

	.type	.L.str.2,%object        @ @.str.2
.L.str.2:
	.asciz	"halide_set_num_threads: must be >= 0."
	.size	.L.str.2, 38

	.type	_ZZ25halide_profiler_get_stateE1s,%object @ @_ZZ25halide_profiler_get_stateE1s
	.data
	.align	3
_ZZ25halide_profiler_get_stateE1s:
	.zero	64
	.long	0                       @ 0x0
	.long	1                       @ 0x1
	.long	0                       @ 0x0
	.long	0                       @ 0x0
	.long	0
	.long	0
	.byte	0                       @ 0x0
	.zero	7
	.size	_ZZ25halide_profiler_get_stateE1s, 96

	.type	.L.str.13,%object       @ @.str.13
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.13:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/profiler.cpp:204 Assert failed: p_stats != NULL\n"
	.size	.L.str.13, 96

	.type	.L.str.1.14,%object     @ @.str.1.14
.L.str.1.14:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/profiler.cpp:231 Assert failed: p_stats != NULL\n"
	.size	.L.str.1.14, 96

	.type	.L.str.2.15,%object     @ @.str.2.15
.L.str.2.15:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/profiler.cpp:232 Assert failed: func_id >= 0\n"
	.size	.L.str.2.15, 93

	.type	.L.str.3,%object        @ @.str.3
.L.str.3:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/profiler.cpp:233 Assert failed: func_id < p_stats->num_funcs\n"
	.size	.L.str.3, 109

	.type	.L.str.4,%object        @ @.str.4
.L.str.4:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/profiler.cpp:267 Assert failed: p_stats != NULL\n"
	.size	.L.str.4, 96

	.type	.L.str.5,%object        @ @.str.5
.L.str.5:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/profiler.cpp:268 Assert failed: func_id >= 0\n"
	.size	.L.str.5, 93

	.type	.L.str.6,%object        @ @.str.6
.L.str.6:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/profiler.cpp:269 Assert failed: func_id < p_stats->num_funcs\n"
	.size	.L.str.6, 109

	.type	.L.str.8.17,%object     @ @.str.8.17
.L.str.8.17:
	.asciz	" total time: "
	.size	.L.str.8.17, 14

	.type	.L.str.9,%object        @ @.str.9
.L.str.9:
	.asciz	" ms"
	.size	.L.str.9, 4

	.type	.L.str.10,%object       @ @.str.10
.L.str.10:
	.asciz	"  samples: "
	.size	.L.str.10, 12

	.type	.L.str.11,%object       @ @.str.11
.L.str.11:
	.asciz	"  runs: "
	.size	.L.str.11, 9

	.type	.L.str.12,%object       @ @.str.12
.L.str.12:
	.asciz	"  time/run: "
	.size	.L.str.12, 13

	.type	.L.str.13.18,%object    @ @.str.13.18
.L.str.13.18:
	.asciz	" ms\n"
	.size	.L.str.13.18, 5

	.type	.L.str.14,%object       @ @.str.14
.L.str.14:
	.asciz	" average threads used: "
	.size	.L.str.14, 24

	.type	.L.str.15,%object       @ @.str.15
.L.str.15:
	.asciz	" heap allocations: "
	.size	.L.str.15, 20

	.type	.L.str.16,%object       @ @.str.16
.L.str.16:
	.asciz	"  peak heap usage: "
	.size	.L.str.16, 20

	.type	.L.str.17,%object       @ @.str.17
.L.str.17:
	.asciz	" bytes\n"
	.size	.L.str.17, 8

	.type	.L.str.18,%object       @ @.str.18
.L.str.18:
	.asciz	"  "
	.size	.L.str.18, 3

	.type	.L.str.19,%object       @ @.str.19
.L.str.19:
	.asciz	": "
	.size	.L.str.19, 3

	.type	.L.str.21,%object       @ @.str.21
.L.str.21:
	.asciz	"ms"
	.size	.L.str.21, 3

	.type	.L.str.23,%object       @ @.str.23
.L.str.23:
	.asciz	"%)"
	.size	.L.str.23, 3

	.type	.L.str.24,%object       @ @.str.24
.L.str.24:
	.asciz	"threads: "
	.size	.L.str.24, 10

	.type	.L.str.25,%object       @ @.str.25
.L.str.25:
	.asciz	" peak: "
	.size	.L.str.25, 8

	.type	.L.str.26,%object       @ @.str.26
.L.str.26:
	.asciz	" num: "
	.size	.L.str.26, 7

	.type	.L.str.27,%object       @ @.str.27
.L.str.27:
	.asciz	" avg: "
	.size	.L.str.27, 7

	.type	.L.str.28,%object       @ @.str.28
.L.str.28:
	.asciz	" stack: "
	.size	.L.str.28, 9

	.type	_ZN6Halide7Runtime8Internal17halide_gpu_deviceE,%object @ @_ZN6Halide7Runtime8Internal17halide_gpu_deviceE
	.bss
	.weak	_ZN6Halide7Runtime8Internal17halide_gpu_deviceE
	.align	2
_ZN6Halide7Runtime8Internal17halide_gpu_deviceE:
	.long	0                       @ 0x0
	.size	_ZN6Halide7Runtime8Internal17halide_gpu_deviceE, 4

	.type	_ZN6Halide7Runtime8Internal22halide_gpu_device_lockE,%object @ @_ZN6Halide7Runtime8Internal22halide_gpu_device_lockE
	.weak	_ZN6Halide7Runtime8Internal22halide_gpu_device_lockE
	.align	2
_ZN6Halide7Runtime8Internal22halide_gpu_device_lockE:
	.long	0                       @ 0x0
	.size	_ZN6Halide7Runtime8Internal22halide_gpu_device_lockE, 4

	.type	_ZN6Halide7Runtime8Internal29halide_gpu_device_initializedE,%object @ @_ZN6Halide7Runtime8Internal29halide_gpu_device_initializedE
	.weak	_ZN6Halide7Runtime8Internal29halide_gpu_device_initializedE
_ZN6Halide7Runtime8Internal29halide_gpu_device_initializedE:
	.byte	0                       @ 0x0
	.size	_ZN6Halide7Runtime8Internal29halide_gpu_device_initializedE, 1

	.type	.L.str.29,%object       @ @.str.29
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.29:
	.asciz	"HL_GPU_DEVICE"
	.size	.L.str.29, 14

	.type	_ZN6Halide7Runtime8Internal17halide_trace_fileE,%object @ @_ZN6Halide7Runtime8Internal17halide_trace_fileE
	.bss
	.weak	_ZN6Halide7Runtime8Internal17halide_trace_fileE
	.align	2
_ZN6Halide7Runtime8Internal17halide_trace_fileE:
	.long	0                       @ 0x0
	.size	_ZN6Halide7Runtime8Internal17halide_trace_fileE, 4

	.type	_ZN6Halide7Runtime8Internal22halide_trace_file_lockE,%object @ @_ZN6Halide7Runtime8Internal22halide_trace_file_lockE
	.weak	_ZN6Halide7Runtime8Internal22halide_trace_file_lockE
	.align	2
_ZN6Halide7Runtime8Internal22halide_trace_file_lockE:
	.long	0                       @ 0x0
	.size	_ZN6Halide7Runtime8Internal22halide_trace_file_lockE, 4

	.type	_ZN6Halide7Runtime8Internal29halide_trace_file_initializedE,%object @ @_ZN6Halide7Runtime8Internal29halide_trace_file_initializedE
	.weak	_ZN6Halide7Runtime8Internal29halide_trace_file_initializedE
_ZN6Halide7Runtime8Internal29halide_trace_file_initializedE:
	.byte	0                       @ 0x0
	.size	_ZN6Halide7Runtime8Internal29halide_trace_file_initializedE, 1

	.type	_ZN6Halide7Runtime8Internal35halide_trace_file_internally_openedE,%object @ @_ZN6Halide7Runtime8Internal35halide_trace_file_internally_openedE
	.weak	_ZN6Halide7Runtime8Internal35halide_trace_file_internally_openedE
_ZN6Halide7Runtime8Internal35halide_trace_file_internally_openedE:
	.byte	0                       @ 0x0
	.size	_ZN6Halide7Runtime8Internal35halide_trace_file_internally_openedE, 1

	.type	_ZN6Halide7Runtime8Internal19halide_custom_traceE,%object @ @_ZN6Halide7Runtime8Internal19halide_custom_traceE
	.section	.data.rel,"aw",%progbits
	.weak	_ZN6Halide7Runtime8Internal19halide_custom_traceE
	.align	2
_ZN6Halide7Runtime8Internal19halide_custom_traceE:
	.long	_ZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_event
	.size	_ZN6Halide7Runtime8Internal19halide_custom_traceE, 4

	.type	_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE3ids,%object @ @_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE3ids
	.data
	.align	2
_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE3ids:
	.long	1                       @ 0x1
	.size	_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE3ids, 4

	.type	.L.str.39,%object       @ @.str.39
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.39:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/tracing.cpp:41 Assert failed: total_bytes <= 4096 && \"Tracing packet too large\"\n"
	.size	.L.str.39, 128

	.type	.L.str.1.40,%object     @ @.str.1.40
.L.str.1.40:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/tracing.cpp:76 Assert failed: written == total_bytes && \"Can't write to trace file\"\n"
	.size	.L.str.1.40, 132

	.type	.L.str.2.41,%object     @ @.str.2.41
.L.str.2.41:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/tracing.cpp:85 Assert failed: print_bits <= 64 && \"Tracing bad type\"\n"
	.size	.L.str.2.41, 117

	.type	.L_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE11event_types,%object @ @_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE11event_types
	.section	.data.rel.ro.local,"aw",%progbits
	.align	2
.L_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE11event_types:
	.long	.L.str.3.58
	.long	.L.str.4.59
	.long	.L.str.5.60
	.long	.L.str.6.61
	.long	.L.str.7.62
	.long	.L.str.8.63
	.long	.L.str.9.64
	.long	.L.str.10.65
	.long	.L.str.11.66
	.long	.L.str.12.67
	.size	.L_ZZN6Halide7Runtime8Internal13default_traceEPvPK18halide_trace_eventE11event_types, 40

	.type	.L.str.13.42,%object    @ @.str.13.42
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.13.42:
	.asciz	" "
	.size	.L.str.13.42, 2

	.type	.L.str.15.44,%object    @ @.str.15.44
.L.str.15.44:
	.asciz	"("
	.size	.L.str.15.44, 2

	.type	.L.str.16.45,%object    @ @.str.16.45
.L.str.16.45:
	.asciz	"<"
	.size	.L.str.16.45, 2

	.type	.L.str.17.46,%object    @ @.str.17.46
.L.str.17.46:
	.asciz	">, <"
	.size	.L.str.17.46, 5

	.type	.L.str.18.47,%object    @ @.str.18.47
.L.str.18.47:
	.asciz	", "
	.size	.L.str.18.47, 3

	.type	.L.str.19.48,%object    @ @.str.19.48
.L.str.19.48:
	.asciz	">)"
	.size	.L.str.19.48, 3

	.type	.L.str.21.50,%object    @ @.str.21.50
.L.str.21.50:
	.asciz	" = <"
	.size	.L.str.21.50, 5

	.type	.L.str.22.51,%object    @ @.str.22.51
.L.str.22.51:
	.asciz	" = "
	.size	.L.str.22.51, 4

	.type	.L.str.23.52,%object    @ @.str.23.52
.L.str.23.52:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/tracing.cpp:153 Assert failed: print_bits >= 16 && \"Tracing a bad type\"\n"
	.size	.L.str.23.52, 120

	.type	.L.str.24.53,%object    @ @.str.24.53
.L.str.24.53:
	.asciz	">"
	.size	.L.str.24.53, 2

	.type	.L.str.25.54,%object    @ @.str.25.54
.L.str.25.54:
	.asciz	"\n"
	.size	.L.str.25.54, 2

	.type	.L.str.26.56,%object    @ @.str.26.56
.L.str.26.56:
	.asciz	"HL_TRACE_FILE"
	.size	.L.str.26.56, 14

	.type	.L.str.27.57,%object    @ @.str.27.57
.L.str.27.57:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/tracing.cpp:210 Assert failed: (fd > 0) && \"Failed to open trace file\\n\"\n"
	.size	.L.str.27.57, 121

	.type	.L.str.3.58,%object     @ @.str.3.58
.L.str.3.58:
	.asciz	"Load"
	.size	.L.str.3.58, 5

	.type	.L.str.4.59,%object     @ @.str.4.59
.L.str.4.59:
	.asciz	"Store"
	.size	.L.str.4.59, 6

	.type	.L.str.5.60,%object     @ @.str.5.60
.L.str.5.60:
	.asciz	"Begin realization"
	.size	.L.str.5.60, 18

	.type	.L.str.6.61,%object     @ @.str.6.61
.L.str.6.61:
	.asciz	"End realization"
	.size	.L.str.6.61, 16

	.type	.L.str.7.62,%object     @ @.str.7.62
.L.str.7.62:
	.asciz	"Produce"
	.size	.L.str.7.62, 8

	.type	.L.str.8.63,%object     @ @.str.8.63
.L.str.8.63:
	.asciz	"Update"
	.size	.L.str.8.63, 7

	.type	.L.str.9.64,%object     @ @.str.9.64
.L.str.9.64:
	.asciz	"Consume"
	.size	.L.str.9.64, 8

	.type	.L.str.10.65,%object    @ @.str.10.65
.L.str.10.65:
	.asciz	"End consume"
	.size	.L.str.10.65, 12

	.type	.L.str.11.66,%object    @ @.str.11.66
.L.str.11.66:
	.asciz	"Begin pipeline"
	.size	.L.str.11.66, 15

	.type	.L.str.12.67,%object    @ @.str.12.67
.L.str.12.67:
	.asciz	"End pipeline"
	.size	.L.str.12.67, 13

	.type	_ZN6Halide7Runtime8Internal30pixel_type_to_tiff_sample_typeE,%object @ @_ZN6Halide7Runtime8Internal30pixel_type_to_tiff_sample_typeE
	.data
	.weak	_ZN6Halide7Runtime8Internal30pixel_type_to_tiff_sample_typeE
	.align	1
_ZN6Halide7Runtime8Internal30pixel_type_to_tiff_sample_typeE:
	.short	3                       @ 0x3
	.short	3                       @ 0x3
	.short	1                       @ 0x1
	.short	2                       @ 0x2
	.short	1                       @ 0x1
	.short	2                       @ 0x2
	.short	1                       @ 0x1
	.short	2                       @ 0x2
	.short	1                       @ 0x1
	.short	2                       @ 0x2
	.size	_ZN6Halide7Runtime8Internal30pixel_type_to_tiff_sample_typeE, 20

	.type	.L.str.68,%object       @ @.str.68
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.68:
	.asciz	"wb"
	.size	.L.str.68, 3

	.type	_ZN6Halide7Runtime8Internal16memoization_lockE,%object @ @_ZN6Halide7Runtime8Internal16memoization_lockE
	.bss
	.weak	_ZN6Halide7Runtime8Internal16memoization_lockE
	.align	3
_ZN6Halide7Runtime8Internal16memoization_lockE:
	.zero	64
	.size	_ZN6Halide7Runtime8Internal16memoization_lockE, 64

	.type	_ZN6Halide7Runtime8Internal13cache_entriesE,%object @ @_ZN6Halide7Runtime8Internal13cache_entriesE
	.weak	_ZN6Halide7Runtime8Internal13cache_entriesE
	.align	2
_ZN6Halide7Runtime8Internal13cache_entriesE:
	.zero	1024
	.size	_ZN6Halide7Runtime8Internal13cache_entriesE, 1024

	.type	_ZN6Halide7Runtime8Internal18most_recently_usedE,%object @ @_ZN6Halide7Runtime8Internal18most_recently_usedE
	.weak	_ZN6Halide7Runtime8Internal18most_recently_usedE
	.align	2
_ZN6Halide7Runtime8Internal18most_recently_usedE:
	.long	0
	.size	_ZN6Halide7Runtime8Internal18most_recently_usedE, 4

	.type	_ZN6Halide7Runtime8Internal19least_recently_usedE,%object @ @_ZN6Halide7Runtime8Internal19least_recently_usedE
	.weak	_ZN6Halide7Runtime8Internal19least_recently_usedE
	.align	2
_ZN6Halide7Runtime8Internal19least_recently_usedE:
	.long	0
	.size	_ZN6Halide7Runtime8Internal19least_recently_usedE, 4

	.type	_ZN6Halide7Runtime8Internal14max_cache_sizeE,%object @ @_ZN6Halide7Runtime8Internal14max_cache_sizeE
	.data
	.weak	_ZN6Halide7Runtime8Internal14max_cache_sizeE
	.align	3
_ZN6Halide7Runtime8Internal14max_cache_sizeE:
	.long	1048576                 @ 0x100000
	.long	0
	.size	_ZN6Halide7Runtime8Internal14max_cache_sizeE, 8

	.type	_ZN6Halide7Runtime8Internal18current_cache_sizeE,%object @ @_ZN6Halide7Runtime8Internal18current_cache_sizeE
	.bss
	.weak	_ZN6Halide7Runtime8Internal18current_cache_sizeE
	.align	3
_ZN6Halide7Runtime8Internal18current_cache_sizeE:
	.long	0                       @ 0x0
	.long	0
	.size	_ZN6Halide7Runtime8Internal18current_cache_sizeE, 8

	.type	.L.str.70,%object       @ @.str.70
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.70:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/cache.cpp:245 Assert failed: prev_hash_entry != NULL\n"
	.size	.L.str.70, 101

	.type	.L.str.1.71,%object     @ @.str.1.71
.L.str.1.71:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/cache.cpp:335 Assert failed: entry->more_recent != NULL\n"
	.size	.L.str.1.71, 104

	.type	.L.str.2.72,%object     @ @.str.2.72
.L.str.2.72:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/cache.cpp:339 Assert failed: least_recently_used == entry\n"
	.size	.L.str.2.72, 106

	.type	.L.str.3.73,%object     @ @.str.3.73
.L.str.3.73:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/cache.cpp:342 Assert failed: entry->more_recent != NULL\n"
	.size	.L.str.3.73, 104

	.type	.L.str.5.74,%object     @ @.str.5.74
.L.str.5.74:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/cache.cpp:433 Assert failed: no_host_pointers_equal\n"
	.size	.L.str.5.74, 100

	.type	.L.str.8.75,%object     @ @.str.8.75
.L.str.8.75:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/cache.cpp:518 Assert failed: entry->in_use_count > 0\n"
	.size	.L.str.8.75, 101

	.type	.L.str.86,%object       @ @.str.86
.L.str.86:
	.asciz	"-nan"
	.size	.L.str.86, 5

	.type	.L.str.1.87,%object     @ @.str.1.87
.L.str.1.87:
	.asciz	"nan"
	.size	.L.str.1.87, 4

	.type	.L.str.2.88,%object     @ @.str.2.88
.L.str.2.88:
	.asciz	"-inf"
	.size	.L.str.2.88, 5

	.type	.L.str.3.89,%object     @ @.str.3.89
.L.str.3.89:
	.asciz	"inf"
	.size	.L.str.3.89, 4

	.type	.L.str.4.90,%object     @ @.str.4.90
.L.str.4.90:
	.asciz	"-0.000000e+00"
	.size	.L.str.4.90, 14

	.type	.L.str.5.91,%object     @ @.str.5.91
.L.str.5.91:
	.asciz	"0.000000e+00"
	.size	.L.str.5.91, 13

	.type	.L.str.6.92,%object     @ @.str.6.92
.L.str.6.92:
	.asciz	"-0.000000"
	.size	.L.str.6.92, 10

	.type	.L.str.7.93,%object     @ @.str.7.93
.L.str.7.93:
	.asciz	"0.000000"
	.size	.L.str.7.93, 9

	.type	.L.str.8.94,%object     @ @.str.8.94
.L.str.8.94:
	.asciz	"-"
	.size	.L.str.8.94, 2

	.type	.L.str.10.96,%object    @ @.str.10.96
.L.str.10.96:
	.asciz	"e+"
	.size	.L.str.10.96, 3

	.type	.L.str.11.97,%object    @ @.str.11.97
.L.str.11.97:
	.asciz	"e-"
	.size	.L.str.11.97, 3

	.type	.L.str.12.98,%object    @ @.str.12.98
.L.str.12.98:
	.asciz	"0123456789abcdef"
	.size	.L.str.12.98, 17

	.type	_ZN6Halide7Runtime8Internal17device_copy_mutexE,%object @ @_ZN6Halide7Runtime8Internal17device_copy_mutexE
	.bss
	.weak	_ZN6Halide7Runtime8Internal17device_copy_mutexE
	.align	3
_ZN6Halide7Runtime8Internal17device_copy_mutexE:
	.zero	64
	.size	_ZN6Halide7Runtime8Internal17device_copy_mutexE, 64

	.type	.L.str.22.105,%object   @ @.str.22.105
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.22.105:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/device_interface.cpp:138 Assert failed: !buf->host_dirty\n"
	.size	.L.str.22.105, 105

	.type	.L.str.37,%object       @ @.str.37
.L.str.37:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/device_interface.cpp:248 Assert failed: buf->dev == 0\n"
	.size	.L.str.37, 102

	.type	.L.str.34,%object       @ @.str.34
.L.str.34:
	.asciz	"halide_device_malloc doesn't support switching interfaces\n"
	.size	.L.str.34, 59

	.type	.L.str.39.106,%object   @ @.str.39.106
.L.str.39.106:
	.asciz	"halide_device_and_host_malloc doesn't support switching interfaces\n"
	.size	.L.str.39.106, 68

	.type	.L.str.41,%object       @ @.str.41
.L.str.41:
	.asciz	"/nobackup/setter/aha/Halide_CoreIR/src/runtime/device_interface.cpp:317 Assert failed: buf->dev == 0\n"
	.size	.L.str.41, 102

	.type	_ZN6Halide7Runtime8Internal9list_headE,%object @ @_ZN6Halide7Runtime8Internal9list_headE
	.bss
	.weak	_ZN6Halide7Runtime8Internal9list_headE
	.align	3
_ZN6Halide7Runtime8Internal9list_headE:
	.zero	72
	.size	_ZN6Halide7Runtime8Internal9list_headE, 72

	.type	.L.str.111,%object      @ @.str.111
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.111:
	.asciz	"Bounds inference call to external stage "
	.size	.L.str.111, 41

	.type	.L.str.1.112,%object    @ @.str.1.112
.L.str.1.112:
	.asciz	" returned non-zero value: "
	.size	.L.str.1.112, 27

	.type	.L.str.2.113,%object    @ @.str.2.113
.L.str.2.113:
	.asciz	"Call to external stage "
	.size	.L.str.2.113, 24

	.type	.L.str.3.114,%object    @ @.str.3.114
.L.str.3.114:
	.asciz	"Bounds given for "
	.size	.L.str.3.114, 18

	.type	.L.str.4.115,%object    @ @.str.4.115
.L.str.4.115:
	.asciz	" in "
	.size	.L.str.4.115, 5

	.type	.L.str.5.116,%object    @ @.str.5.116
.L.str.5.116:
	.asciz	" (from "
	.size	.L.str.5.116, 8

	.type	.L.str.6.117,%object    @ @.str.6.117
.L.str.6.117:
	.asciz	" to "
	.size	.L.str.6.117, 5

	.type	.L.str.7.118,%object    @ @.str.7.118
.L.str.7.118:
	.asciz	") do not cover required region (from "
	.size	.L.str.7.118, 38

	.type	.L.str.8.119,%object    @ @.str.8.119
.L.str.8.119:
	.asciz	")"
	.size	.L.str.8.119, 2

	.type	.L.str.9.120,%object    @ @.str.9.120
.L.str.9.120:
	.asciz	" has type "
	.size	.L.str.9.120, 11

	.type	.L.str.10.121,%object   @ @.str.10.121
.L.str.10.121:
	.asciz	" but elem_size of the buffer passed in is "
	.size	.L.str.10.121, 43

	.type	.L.str.11.122,%object   @ @.str.11.122
.L.str.11.122:
	.asciz	" instead of "
	.size	.L.str.11.122, 13

	.type	.L.str.12.123,%object   @ @.str.12.123
.L.str.12.123:
	.asciz	" is accessed at "
	.size	.L.str.12.123, 17

	.type	.L.str.13.124,%object   @ @.str.13.124
.L.str.13.124:
	.asciz	", which is before the min ("
	.size	.L.str.13.124, 28

	.type	.L.str.14.125,%object   @ @.str.14.125
.L.str.14.125:
	.asciz	") in dimension "
	.size	.L.str.14.125, 16

	.type	.L.str.15.126,%object   @ @.str.15.126
.L.str.15.126:
	.asciz	", which is beyond the max ("
	.size	.L.str.15.126, 28

	.type	.L.str.16.127,%object   @ @.str.16.127
.L.str.16.127:
	.asciz	"Total allocation for buffer "
	.size	.L.str.16.127, 29

	.type	.L.str.17.128,%object   @ @.str.17.128
.L.str.17.128:
	.asciz	" is "
	.size	.L.str.17.128, 5

	.type	.L.str.18.129,%object   @ @.str.18.129
.L.str.18.129:
	.asciz	", which exceeds the maximum size of "
	.size	.L.str.18.129, 37

	.type	.L.str.19.130,%object   @ @.str.19.130
.L.str.19.130:
	.asciz	"Product of extents for buffer "
	.size	.L.str.19.130, 31

	.type	.L.str.20.131,%object   @ @.str.20.131
.L.str.20.131:
	.asciz	"Applying the constraints on "
	.size	.L.str.20.131, 29

	.type	.L.str.21.132,%object   @ @.str.21.132
.L.str.21.132:
	.asciz	" to the required region made it smaller. "
	.size	.L.str.21.132, 42

	.type	.L.str.22.133,%object   @ @.str.22.133
.L.str.22.133:
	.asciz	"Required size: "
	.size	.L.str.22.133, 16

	.type	.L.str.23.134,%object   @ @.str.23.134
.L.str.23.134:
	.asciz	". "
	.size	.L.str.23.134, 3

	.type	.L.str.24.135,%object   @ @.str.24.135
.L.str.24.135:
	.asciz	"Constrained size: "
	.size	.L.str.24.135, 19

	.type	.L.str.25.136,%object   @ @.str.25.136
.L.str.25.136:
	.asciz	"."
	.size	.L.str.25.136, 2

	.type	.L.str.26.137,%object   @ @.str.26.137
.L.str.26.137:
	.asciz	"Constraint violated: "
	.size	.L.str.26.137, 22

	.type	.L.str.27.138,%object   @ @.str.27.138
.L.str.27.138:
	.asciz	" ("
	.size	.L.str.27.138, 3

	.type	.L.str.28.139,%object   @ @.str.28.139
.L.str.28.139:
	.asciz	") == "
	.size	.L.str.28.139, 6

	.type	.L.str.29.140,%object   @ @.str.29.140
.L.str.29.140:
	.asciz	"Parameter "
	.size	.L.str.29.140, 11

	.type	.L.str.30,%object       @ @.str.30
.L.str.30:
	.asciz	" but must be at least "
	.size	.L.str.30, 23

	.type	.L.str.31,%object       @ @.str.31
.L.str.31:
	.asciz	" but must be at most "
	.size	.L.str.31, 22

	.type	.L.str.32,%object       @ @.str.32
.L.str.32:
	.asciz	"Out of memory (halide_malloc returned NULL)"
	.size	.L.str.32, 44

	.type	.L.str.33,%object       @ @.str.33
.L.str.33:
	.asciz	"Buffer argument "
	.size	.L.str.33, 17

	.type	.L.str.34.141,%object   @ @.str.34.141
.L.str.34.141:
	.asciz	" is NULL"
	.size	.L.str.34.141, 9

	.type	.L.str.35,%object       @ @.str.35
.L.str.35:
	.asciz	"Failed to dump function "
	.size	.L.str.35, 25

	.type	.L.str.36,%object       @ @.str.36
.L.str.36:
	.asciz	" to file "
	.size	.L.str.36, 10

	.type	.L.str.37.142,%object   @ @.str.37.142
.L.str.37.142:
	.asciz	" with error "
	.size	.L.str.37.142, 13

	.type	.L.str.38,%object       @ @.str.38
.L.str.38:
	.asciz	"The host pointer of "
	.size	.L.str.38, 21

	.type	.L.str.39.143,%object   @ @.str.39.143
.L.str.39.143:
	.asciz	" is not aligned to a "
	.size	.L.str.39.143, 22

	.type	.L.str.40,%object       @ @.str.40
.L.str.40:
	.asciz	" bytes boundary."
	.size	.L.str.40, 17

	.type	.L.str.41.144,%object   @ @.str.41.144
.L.str.41.144:
	.asciz	"The folded storage dimension "
	.size	.L.str.41.144, 30

	.type	.L.str.42.145,%object   @ @.str.42.145
.L.str.42.145:
	.asciz	" of "
	.size	.L.str.42.145, 5

	.type	.L.str.43,%object       @ @.str.43
.L.str.43:
	.asciz	" was accessed out of order by loop "
	.size	.L.str.43, 36

	.type	.L.str.44,%object       @ @.str.44
.L.str.44:
	.asciz	"The fold factor ("
	.size	.L.str.44, 18

	.type	.L.str.45,%object       @ @.str.45
.L.str.45:
	.asciz	") of dimension "
	.size	.L.str.45, 16

	.type	.L.str.46,%object       @ @.str.46
.L.str.46:
	.asciz	" is too small to store the required region accessed by loop "
	.size	.L.str.46, 61

	.type	.L.str.47,%object       @ @.str.47
.L.str.47:
	.asciz	")."
	.size	.L.str.47, 3

	.type	_ZN6Halide7Runtime8Internal30custom_can_use_target_featuresE,%object @ @_ZN6Halide7Runtime8Internal30custom_can_use_target_featuresE
	.section	.data.rel,"aw",%progbits
	.weak	_ZN6Halide7Runtime8Internal30custom_can_use_target_featuresE
	.align	2
_ZN6Halide7Runtime8Internal30custom_can_use_target_featuresE:
	.long	halide_default_can_use_target_features
	.size	_ZN6Halide7Runtime8Internal30custom_can_use_target_featuresE, 4

	.type	.L.str.1.148,%object    @ @.str.1.148
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.1.148:
	.asciz	"Zynq runtime is already initialized.\n"
	.size	.L.str.1.148, 38

	.type	.L.str.18.149,%object   @ @.str.18.149
.L.str.18.149:
	.asciz	"Printer buffer allocation failed.\n"
	.size	.L.str.18.149, 35

	.type	.L.str.2.150,%object    @ @.str.2.150
.L.str.2.150:
	.asciz	"/dev/cmabuffer0"
	.size	.L.str.2.150, 16

	.type	.L.str.3.151,%object    @ @.str.3.151
.L.str.3.151:
	.asciz	"Failed to open cma provider!\n"
	.size	.L.str.3.151, 30

	.type	.L.str.4.152,%object    @ @.str.4.152
.L.str.4.152:
	.asciz	"/dev/hwacc0"
	.size	.L.str.4.152, 12

	.type	.L.str.5.153,%object    @ @.str.5.153
.L.str.5.153:
	.asciz	"Failed to open hwacc device!\n"
	.size	.L.str.5.153, 30

	.type	.L.str.8.154,%object    @ @.str.8.154
.L.str.8.154:
	.asciz	"Zynq runtime is uninitialized.\n"
	.size	.L.str.8.154, 32

	.type	.L.str.9.155,%object    @ @.str.9.155
.L.str.9.155:
	.asciz	"malloc failed.\n"
	.size	.L.str.9.155, 16

	.type	.L.str.10.156,%object   @ @.str.10.156
.L.str.10.156:
	.asciz	"buffer_t has less than 2 dimension, not supported in CMA driver."
	.size	.L.str.10.156, 65

	.type	.L.str.11.157,%object   @ @.str.11.157
.L.str.11.157:
	.asciz	"cma_get_buffer() returned"
	.size	.L.str.11.157, 26

	.type	.L.str.12.158,%object   @ @.str.12.158
.L.str.12.158:
	.asciz	" (failed).\n"
	.size	.L.str.12.158, 12

	.type	.L.str.13.159,%object   @ @.str.13.159
.L.str.13.159:
	.asciz	"mmap failed.\n"
	.size	.L.str.13.159, 14

	.type	.Lstr,%object           @ @str
	.section	.rodata,"a",%progbits
	.align	5
.Lstr:
	.asciz	"p2:input"
	.size	.Lstr, 9

	.type	.Lstr.160,%object       @ @str.160
	.align	5
.Lstr.160:
	.asciz	"p2:processed"
	.size	.Lstr.160, 13

	.type	.Lstr.161,%object       @ @str.161
	.align	5
.Lstr.161:
	.asciz	"Input buffer p2:input"
	.size	.Lstr.161, 22

	.type	.Lstr.162,%object       @ @str.162
	.align	5
.Lstr.162:
	.asciz	"uint16"
	.size	.Lstr.162, 7

	.type	.Lstr.163,%object       @ @str.163
	.align	5
.Lstr.163:
	.asciz	"Output buffer p2:processed"
	.size	.Lstr.163, 27

	.type	.Lstr.164,%object       @ @str.164
	.align	5
.Lstr.164:
	.asciz	"uint8"
	.size	.Lstr.164, 6

	.type	.Lstr.165,%object       @ @str.165
	.align	5
.Lstr.165:
	.asciz	"p2:input.stride.0"
	.size	.Lstr.165, 18

	.type	.Lstr.166,%object       @ @str.166
	.align	5
.Lstr.166:
	.asciz	"1"
	.size	.Lstr.166, 2

	.type	.Lstr.167,%object       @ @str.167
	.align	5
.Lstr.167:
	.asciz	"p2:processed.stride.0"
	.size	.Lstr.167, 22

	.type	.Lstr.168,%object       @ @str.168
	.align	5
.Lstr.168:
	.asciz	"c"
	.size	.Lstr.168, 2

	.type	.Lstr.169,%object       @ @str.169
	.align	5
.Lstr.169:
	.asciz	"y"
	.size	.Lstr.169, 2

	.type	.Lstr.170,%object       @ @str.170
	.align	5
.Lstr.170:
	.asciz	"x"
	.size	.Lstr.170, 2

	.type	.L__unnamed_1,%object   @ @0
	.section	.data.rel.ro.local,"aw",%progbits
	.align	4
.L__unnamed_1:
	.long	.Lstr
	.long	1                       @ 0x1
	.long	2                       @ 0x2
	.byte	1                       @ 0x1
	.byte	16                      @ 0x10
	.short	1                       @ 0x1
	.long	0
	.long	0
	.long	0
	.long	.Lstr.160
	.long	2                       @ 0x2
	.long	3                       @ 0x3
	.byte	1                       @ 0x1
	.byte	8                       @ 0x8
	.short	1                       @ 0x1
	.long	0
	.long	0
	.long	0
	.size	.L__unnamed_1, 56

	.type	.Lstr.171,%object       @ @str.171
	.section	.rodata,"a",%progbits
	.align	5
.Lstr.171:
	.asciz	"arm-32-linux-zynq"
	.size	.Lstr.171, 18

	.type	.Lstr.172,%object       @ @str.172
	.align	5
.Lstr.172:
	.asciz	"pipeline_zynq"
	.size	.Lstr.172, 14

	.type	.Lpipeline_zynq_metadata_storage,%object @ @pipeline_zynq_metadata_storage
	.section	.data.rel.ro.local,"aw",%progbits
	.align	4
.Lpipeline_zynq_metadata_storage:
	.long	0                       @ 0x0
	.long	2                       @ 0x2
	.long	.L__unnamed_1
	.long	.Lstr.171
	.long	.Lstr.172
	.size	.Lpipeline_zynq_metadata_storage, 20

	.type	_MergedGlobals,%object  @ @_MergedGlobals
	.local	_MergedGlobals
	.comm	_MergedGlobals,32,8

	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.ident	"clang version 3.7.1 (tags/RELEASE_371/final)"
	.section	".note.GNU-stack","",%progbits
