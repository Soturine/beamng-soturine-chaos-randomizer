<template>
  <div class="scr-field scr-select" :class="{ 'is-invalid': invalid }">
    <span v-if="label">{{ label }}</span>
    <BngSmartSelect
      ref="control"
      v-model="model"
      class="scr-smart-select"
      :items="normalizedItems"
      type="dropdown"
      :disabled="disabled"
      :title="selectedLabel"
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
import { normalizeSelectItems } from "../../services/selectAdapter.js"

const model = defineModel({ default: "" })
const props = defineProps({
  items: { type: [Array, Object], default: () => [] },
  label: { type: String, default: "" },
  ariaLabel: { type: String, default: "" },
  description: { type: String, default: "" },
  disabled: { type: Boolean, default: false },
  invalid: { type: Boolean, default: false },
})
const emit = defineEmits(["change"])
const control = ref(null)

const normalizedItems = computed(() => normalizeSelectItems(props.items))
const selectedLabel = computed(() => normalizedItems.value
  .find(item => Object.is(item.value, model.value))?.label || "")

defineExpose({
  openDropdown: (...args) => control.value?.openDropdown?.(...args),
})
</script>
