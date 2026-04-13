<script setup lang="ts">
defineEmits<{
  (e: 'increment'): void;
  (e: 'decrement'): void;
}>();
</script>

<template>
  <div class="controls-area">
    <button class="control-btn minus" @click="$emit('decrement')" @touchstart.prevent="$emit('decrement')">
      −
    </button>
    <button class="control-btn plus" @click="$emit('increment')" @touchstart.prevent="$emit('increment')">
      +
    </button>
  </div>
</template>

<style scoped>
.controls-area {
  height: 35vh;
  display: flex;
  gap: 24px;
  padding: 24px;
  padding-bottom: 120px;
  width: 100%;
  box-sizing: border-box;
}

.control-btn {
  flex: 1;
  border: none;
  border-radius: 24px;
  font-size: 60px;
  color: white;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
  transition: opacity 0.2s, transform 0.1s;
}

.control-btn:active {
  transform: scale(0.98);
  opacity: 0.8;
}

.plus {
  background-color: #34c759;
}

.minus {
  background-color: #ff3b30;
}

@media (max-width: 600px) {
  .controls-area {
    height: 35vh;
    padding: 12px;
    padding-bottom: 140px;
    gap: 12px;
  }

  .control-btn {
    font-size: 40px;
    border-radius: 16px;
  }
}
</style>
