<script setup lang="ts">
defineProps<{
  count: number;
}>();
</script>

<template>
  <div class="display-area">
    <span class="count-number">{{ count }}</span>
  </div>
</template>

<style scoped>
.display-area {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.count-number {
  font-size: 180px;
  font-weight: 700;
  color: #1c1c1e;
  font-variant-numeric: tabular-nums;
}

@media (max-width: 600px) {
  .count-number {
    font-size: 100px;
  }
}
</style>
