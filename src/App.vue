<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { useCounter } from './composables/useCounter';

import AppHeader from './components/AppHeader.vue';
import CounterDisplay from './components/CounterDisplay.vue';
import CounterControls from './components/CounterControls.vue';

const { count, initCounter, stopListening, increment, decrement, reset } = useCounter();

const isAuthorized = ref(false);

onMounted(async () => {
  try {
    const res = await fetch('/api/session.php');
    if (!res.ok) return;
    const data: { authorized: boolean } = await res.json();
    if (!data.authorized) return;

    isAuthorized.value = true;
    initCounter();
  } catch {
    // ネットワークエラーは未認証として扱う
  }
});

onUnmounted(() => {
  stopListening();
});
</script>

<template>
  <div class="app-container">
    <template v-if="isAuthorized">
      <AppHeader @reset="reset" />
      <CounterDisplay :count="count" />
      <CounterControls @increment="increment" @decrement="decrement" />
    </template>
    <div v-else class="unauthorized">
      <p>アクセス権限がありません</p>
    </div>
  </div>
</template>

<style scoped>
.unauthorized {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #8e8e93;
  font-size: 18px;
}

.app-container {
  height: 100dvh;
  width: 100%;
  max-width: 820px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  background-color: #f2f2f7;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  user-select: none;
  touch-action: manipulation;
  overflow: hidden;
  box-shadow: 0 0 40px rgba(0, 0, 0, 0.1);
}
</style>
