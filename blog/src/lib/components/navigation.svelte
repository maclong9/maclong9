<script lang="ts">
	import { cn } from '$lib';
	import { buttonVariants, type Variant } from '$lib/components/ui/button';
	import EnvelopeClosed from 'svelte-radix/EnvelopeClosed.svelte';
	import GithubLogo from 'svelte-radix/GithubLogo.svelte';
	import DarkToggle from './ui/dark-toggle.svelte';

	let { withLabel } = $props<{ withLabel?: boolean }>();

	const links = [
		{
			href: 'mailto:maclong9@icloud.com',
			label: 'Email',
			variant: 'secondary',
			Icon: EnvelopeClosed
		},
		{
			href: 'https://github.com/maclong9',
			label: 'Github',
			variant: 'primary',
			Icon: GithubLogo
		}
	];
</script>

<nav class="flex items-center gap-1">
	{#each links as { href, label, variant, Icon }}
		<a
			{href}
			class={cn(
				withLabel
					? ['gap-2', buttonVariants({ variant: variant as Variant })]
					: buttonVariants({ variant: 'ghost', size: 'icon' })
			)}
		>
			<Icon />
			{#if withLabel}
				<span>{label}</span>
			{/if}
		</a>
	{/each}
	{#if !withLabel}
		<DarkToggle />
	{/if}
</nav>
