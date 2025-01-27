<script lang="ts">
	import { cn } from '$lib';
	import { buttonVariants, type ButtonVariant } from '$lib/components/ui/button';
	import { Mail, Github } from 'lucide-svelte';
	import LightSwitch from '$lib/components/ui/light-switch.svelte';

	let { withLabel } = $props<{ withLabel?: boolean }>();

	const links = [
		{
			href: 'mailto:maclong9@icloud.com',
			label: 'Email',
			variant: 'secondary',
			Icon: Mail
		},
		{
			href: 'https://github.com/maclong9',
			label: 'Github',
			Icon: Github
		}
	];
</script>

<nav class="flex items-center gap-4">
	<div class={cn(withLabel && 'space-x-2')}>
		{#each links as { href, label, variant, Icon }}
			<a
				{href}
				class={cn(
					withLabel
						? ['gap-2', buttonVariants({ variant: variant as ButtonVariant })]
						: buttonVariants({ variant: 'ghost', size: 'icon' })
				)}
			>
				<Icon />
				{#if withLabel}
					<span>{label}</span>
				{/if}
			</a>
		{/each}
	</div>
	{#if !withLabel}
		<LightSwitch />
	{/if}
</nav>
