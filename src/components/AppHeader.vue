<script setup lang="ts">
defineEmits<{
  (e: 'reset'): void;
}>();
</script>

<template>
  <header class="header">
    <span class="status">Connected</span>
    <button @click="$emit('reset')" class="btn sm-btn">Reset</button>
  </header>
</template>

<style scoped>
.header {
  padding: 16px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
}

.btn {
  border: none;
  cursor: pointer;
  font-weight: 600;
  transition: opacity 0.2s;
}

.sm-btn {
  background: transparent;
  color: #007aff;
  font-size: 16px;
}
</style>
