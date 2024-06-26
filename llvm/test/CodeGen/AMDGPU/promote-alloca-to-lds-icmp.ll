; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-unknown-amdhsa -mcpu=kaveri -passes=amdgpu-promote-alloca < %s | FileCheck %s
; RUN: opt -S -mtriple=amdgcn-unknown-amdhsa -mcpu=kaveri -passes=amdgpu-promote-alloca -disable-promote-alloca-to-lds< %s | FileCheck -check-prefix=NOLDS %s

; This normally would be fixed by instcombine to be compare to the GEP
; indices

define amdgpu_kernel void @lds_promoted_alloca_icmp_same_derived_pointer(ptr addrspace(1) %out, i32 %a, i32 %b) #0 {
; CHECK-LABEL: @lds_promoted_alloca_icmp_same_derived_pointer(
; CHECK-NEXT:    [[TMP1:%.*]] = call noalias nonnull dereferenceable(64) ptr addrspace(4) @llvm.amdgcn.dispatch.ptr()
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, ptr addrspace(4) [[TMP1]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr addrspace(4) [[TMP2]], align 4, !invariant.load [[META0:![0-9]+]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, ptr addrspace(4) [[TMP1]], i64 2
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr addrspace(4) [[TMP4]], align 4, !range [[RNG1:![0-9]+]], !invariant.load [[META0]]
; CHECK-NEXT:    [[TMP6:%.*]] = lshr i32 [[TMP3]], 16
; CHECK-NEXT:    [[TMP7:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.x()
; CHECK-NEXT:    [[TMP8:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.y()
; CHECK-NEXT:    [[TMP9:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.z()
; CHECK-NEXT:    [[TMP10:%.*]] = mul nuw nsw i32 [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP11:%.*]] = mul i32 [[TMP10]], [[TMP7]]
; CHECK-NEXT:    [[TMP12:%.*]] = mul nuw nsw i32 [[TMP8]], [[TMP5]]
; CHECK-NEXT:    [[TMP13:%.*]] = add i32 [[TMP11]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = add i32 [[TMP13]], [[TMP9]]
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [256 x [16 x i32]], ptr addrspace(3) @lds_promoted_alloca_icmp_same_derived_pointer.alloca, i32 0, i32 [[TMP14]]
; CHECK-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(3) [[TMP15]], i32 0, i32 [[A:%.*]]
; CHECK-NEXT:    [[PTR1:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(3) [[TMP15]], i32 0, i32 [[B:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(3) [[PTR0]], [[PTR1]]
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    store volatile i32 [[ZEXT]], ptr addrspace(1) [[OUT:%.*]], align 4
; CHECK-NEXT:    ret void
;
; NOLDS-LABEL: @lds_promoted_alloca_icmp_same_derived_pointer(
; NOLDS-NEXT:    [[ALLOCA:%.*]] = alloca [16 x i32], align 4, addrspace(5)
; NOLDS-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[A:%.*]]
; NOLDS-NEXT:    [[PTR1:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[B:%.*]]
; NOLDS-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(5) [[PTR0]], [[PTR1]]
; NOLDS-NEXT:    [[ZEXT:%.*]] = zext i1 [[CMP]] to i32
; NOLDS-NEXT:    store volatile i32 [[ZEXT]], ptr addrspace(1) [[OUT:%.*]], align 4
; NOLDS-NEXT:    ret void
;
  %alloca = alloca [16 x i32], align 4, addrspace(5)
  %ptr0 = getelementptr inbounds [16 x i32], ptr addrspace(5) %alloca, i32 0, i32 %a
  %ptr1 = getelementptr inbounds [16 x i32], ptr addrspace(5) %alloca, i32 0, i32 %b
  %cmp = icmp eq ptr addrspace(5) %ptr0, %ptr1
  %zext = zext i1 %cmp to i32
  store volatile i32 %zext, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @lds_promoted_alloca_icmp_null_rhs(ptr addrspace(1) %out, i32 %a, i32 %b) #0 {
; CHECK-LABEL: @lds_promoted_alloca_icmp_null_rhs(
; CHECK-NEXT:    [[TMP1:%.*]] = call noalias nonnull dereferenceable(64) ptr addrspace(4) @llvm.amdgcn.dispatch.ptr()
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, ptr addrspace(4) [[TMP1]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr addrspace(4) [[TMP2]], align 4, !invariant.load [[META0]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, ptr addrspace(4) [[TMP1]], i64 2
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr addrspace(4) [[TMP4]], align 4, !range [[RNG1]], !invariant.load [[META0]]
; CHECK-NEXT:    [[TMP6:%.*]] = lshr i32 [[TMP3]], 16
; CHECK-NEXT:    [[TMP7:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.x()
; CHECK-NEXT:    [[TMP8:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.y()
; CHECK-NEXT:    [[TMP9:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.z()
; CHECK-NEXT:    [[TMP10:%.*]] = mul nuw nsw i32 [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP11:%.*]] = mul i32 [[TMP10]], [[TMP7]]
; CHECK-NEXT:    [[TMP12:%.*]] = mul nuw nsw i32 [[TMP8]], [[TMP5]]
; CHECK-NEXT:    [[TMP13:%.*]] = add i32 [[TMP11]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = add i32 [[TMP13]], [[TMP9]]
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [256 x [16 x i32]], ptr addrspace(3) @lds_promoted_alloca_icmp_null_rhs.alloca, i32 0, i32 [[TMP14]]
; CHECK-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(3) [[TMP15]], i32 0, i32 [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(3) [[PTR0]], null
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    store volatile i32 [[ZEXT]], ptr addrspace(1) [[OUT:%.*]], align 4
; CHECK-NEXT:    ret void
;
; NOLDS-LABEL: @lds_promoted_alloca_icmp_null_rhs(
; NOLDS-NEXT:    [[ALLOCA:%.*]] = alloca [16 x i32], align 4, addrspace(5)
; NOLDS-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[A:%.*]]
; NOLDS-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(5) [[PTR0]], null
; NOLDS-NEXT:    [[ZEXT:%.*]] = zext i1 [[CMP]] to i32
; NOLDS-NEXT:    store volatile i32 [[ZEXT]], ptr addrspace(1) [[OUT:%.*]], align 4
; NOLDS-NEXT:    ret void
;
  %alloca = alloca [16 x i32], align 4, addrspace(5)
  %ptr0 = getelementptr inbounds [16 x i32], ptr addrspace(5) %alloca, i32 0, i32 %a
  %cmp = icmp eq ptr addrspace(5) %ptr0, null
  %zext = zext i1 %cmp to i32
  store volatile i32 %zext, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @lds_promoted_alloca_icmp_null_lhs(ptr addrspace(1) %out, i32 %a, i32 %b) #0 {
; CHECK-LABEL: @lds_promoted_alloca_icmp_null_lhs(
; CHECK-NEXT:    [[TMP1:%.*]] = call noalias nonnull dereferenceable(64) ptr addrspace(4) @llvm.amdgcn.dispatch.ptr()
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, ptr addrspace(4) [[TMP1]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr addrspace(4) [[TMP2]], align 4, !invariant.load [[META0]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, ptr addrspace(4) [[TMP1]], i64 2
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr addrspace(4) [[TMP4]], align 4, !range [[RNG1]], !invariant.load [[META0]]
; CHECK-NEXT:    [[TMP6:%.*]] = lshr i32 [[TMP3]], 16
; CHECK-NEXT:    [[TMP7:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.x()
; CHECK-NEXT:    [[TMP8:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.y()
; CHECK-NEXT:    [[TMP9:%.*]] = call range(i32 0, 256) i32 @llvm.amdgcn.workitem.id.z()
; CHECK-NEXT:    [[TMP10:%.*]] = mul nuw nsw i32 [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP11:%.*]] = mul i32 [[TMP10]], [[TMP7]]
; CHECK-NEXT:    [[TMP12:%.*]] = mul nuw nsw i32 [[TMP8]], [[TMP5]]
; CHECK-NEXT:    [[TMP13:%.*]] = add i32 [[TMP11]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = add i32 [[TMP13]], [[TMP9]]
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [256 x [16 x i32]], ptr addrspace(3) @lds_promoted_alloca_icmp_null_lhs.alloca, i32 0, i32 [[TMP14]]
; CHECK-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(3) [[TMP15]], i32 0, i32 [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(3) null, [[PTR0]]
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    store volatile i32 [[ZEXT]], ptr addrspace(1) [[OUT:%.*]], align 4
; CHECK-NEXT:    ret void
;
; NOLDS-LABEL: @lds_promoted_alloca_icmp_null_lhs(
; NOLDS-NEXT:    [[ALLOCA:%.*]] = alloca [16 x i32], align 4, addrspace(5)
; NOLDS-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[A:%.*]]
; NOLDS-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(5) null, [[PTR0]]
; NOLDS-NEXT:    [[ZEXT:%.*]] = zext i1 [[CMP]] to i32
; NOLDS-NEXT:    store volatile i32 [[ZEXT]], ptr addrspace(1) [[OUT:%.*]], align 4
; NOLDS-NEXT:    ret void
;
  %alloca = alloca [16 x i32], align 4, addrspace(5)
  %ptr0 = getelementptr inbounds [16 x i32], ptr addrspace(5) %alloca, i32 0, i32 %a
  %cmp = icmp eq ptr addrspace(5) null, %ptr0
  %zext = zext i1 %cmp to i32
  store volatile i32 %zext, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @lds_promoted_alloca_icmp_unknown_ptr(ptr addrspace(1) %out, i32 %a, i32 %b) #0 {
; CHECK-LABEL: @lds_promoted_alloca_icmp_unknown_ptr(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [16 x i32], align 4, addrspace(5)
; CHECK-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[A:%.*]]
; CHECK-NEXT:    [[PTR1:%.*]] = call ptr addrspace(5) @get_unknown_pointer()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(5) [[PTR0]], [[PTR1]]
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    store volatile i32 [[ZEXT]], ptr addrspace(1) [[OUT:%.*]], align 4
; CHECK-NEXT:    ret void
;
; NOLDS-LABEL: @lds_promoted_alloca_icmp_unknown_ptr(
; NOLDS-NEXT:    [[ALLOCA:%.*]] = alloca [16 x i32], align 4, addrspace(5)
; NOLDS-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [16 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[A:%.*]]
; NOLDS-NEXT:    [[PTR1:%.*]] = call ptr addrspace(5) @get_unknown_pointer()
; NOLDS-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(5) [[PTR0]], [[PTR1]]
; NOLDS-NEXT:    [[ZEXT:%.*]] = zext i1 [[CMP]] to i32
; NOLDS-NEXT:    store volatile i32 [[ZEXT]], ptr addrspace(1) [[OUT:%.*]], align 4
; NOLDS-NEXT:    ret void
;
  %alloca = alloca [16 x i32], align 4, addrspace(5)
  %ptr0 = getelementptr inbounds [16 x i32], ptr addrspace(5) %alloca, i32 0, i32 %a
  %ptr1 = call ptr addrspace(5) @get_unknown_pointer()
  %cmp = icmp eq ptr addrspace(5) %ptr0, %ptr1
  %zext = zext i1 %cmp to i32
  store volatile i32 %zext, ptr addrspace(1) %out
  ret void
}

declare ptr addrspace(5) @get_unknown_pointer() #0

attributes #0 = { nounwind "amdgpu-waves-per-eu"="1,1" "amdgpu-flat-work-group-size"="1,256" }
