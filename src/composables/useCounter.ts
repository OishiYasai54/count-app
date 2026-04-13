import { ref } from 'vue';

export function useCounter() {
  const count = ref<number>(0);
  let intervalId: number | null = null;

  // 現在のカウントを取得する関数
  const fetchCount = async () => {
    try {
      const res = await fetch('/api/count.php');
      if (res.ok) {
        const data = await res.json();
        count.value = data.value;
      } else if (res.status === 401) {
        // セッション切れなどの場合
        stopListening();
      }
    } catch (e) {
      console.error('Fetch error:', e);
    }
  };

  const initCounter = () => {
    fetchCount(); // 初回取得
    // 1秒ごとにポーリングして同期
    intervalId = window.setInterval(fetchCount, 1000);
  };

  const stopListening = () => {
    if (intervalId) {
      clearInterval(intervalId);
      intervalId = null;
    }
  };

  // 更新処理共通化
  const update = async (delta: number, reset = false) => {
    await fetch('/api/count.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ delta, reset }),
    });
    fetchCount(); // 更新後に即再取得
  };

  const increment = () => update(1);
  const decrement = () => update(-1);
  const reset = () => {
    if (confirm('カウントを0に戻しますか？')) {
      update(0, true);
    }
  };

  return {
    count,
    initCounter,
    stopListening,
    increment,
    decrement,
    reset,
  };
}
