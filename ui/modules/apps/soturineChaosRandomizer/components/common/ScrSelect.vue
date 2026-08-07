<template>
  <div class="scr-field scr-select" :class="{ 'is-invalid': invalid }">
    <span v-if="label">{{ label }}</span>
    <BngSmartSelect
      ref="control"
      v-model="model"
      :items="normalizedItems"
      type="dropdown"
      :disabled="disabled"
      :aria-label="ariaLabel || label"
      :aria-invalid="invalid ? 'true' : undefined"
      @change="emit('change', $event)"
    />
    <small v-if="description">{{ description }}</small>
  </div>
</template>

<script setup>
import { computed, ref } from "vue"
import { BngSmartSelect } from "@/common/components/base"

const model = defineModel({ default: "" })
const props = defineProps({
  items: { type: Array, default: () => [] },
  label: { type: String, default: "" },
  ariaLabel: { type: String, default: "" },
  description: { type: String, default: "" },
  disabled: { type: Boolean, default: false },
  invalid: { type: Boolean, default: false },
})
const emit = defineEmits(["change"])
const control = ref(null)

const normalizedItems = computed(() => props.items.map(item => {
  if (item && typeof item === "object") {
    const value = item.value ?? item.id ?? item.label
    return { ...item, value, label: String(item.label ?? value ?? "") }
  }
  return { value: item, label: String(item ?? "") }
}))

defineExpose({
  openDropdown: (...args) => control.value?.openDropdown?.(...args),
})
</script>
